#include <png.h>
#include <stdio.h>
#include <emmintrin.h>
#include <smmintrin.h>
#define ERROR                                                   \
	fprintf (stderr, "ERROR at %s:%d.\n", __FILE__, __LINE__) ;   \
	return -1 ;                                                   \

void fil(unsigned char * M, int i, int j, int width);

unsigned long long int timer();

void 
filter
(
	unsigned char * M, unsigned char * W, 
	int width, int height
) ;


int main (int argc, char ** argv)
{
	if (2 != argc)
	{
		printf ("\nUsage:\n\n%s file_name.png\n\n", argv[0]) ;

		return 0 ;
	}

	const char * file_name = argv [1] ;
	
	#define HEADER_SIZE (1)
	unsigned char header [HEADER_SIZE] ;

	FILE *fp = fopen (file_name, "rb");
	if (NULL == fp)
	{
		fprintf (stderr, "Can not open file \"%s\".\n", file_name) ;
		ERROR
	}

	if (fread (header, 1, HEADER_SIZE, fp) != HEADER_SIZE)
	{
		ERROR
	}

	if (0 != png_sig_cmp (header, 0, HEADER_SIZE))
	{
		ERROR
	}

	png_structp png_ptr = 
		png_create_read_struct
			(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL );
	if (NULL == png_ptr)
	{
		ERROR
	}

	png_infop info_ptr = png_create_info_struct (png_ptr);
	if (NULL == info_ptr)
	{
		png_destroy_read_struct (& png_ptr, NULL, NULL);

		ERROR
	}

	if (setjmp (png_jmpbuf (png_ptr))) 
	{
		png_destroy_read_struct (& png_ptr, & info_ptr, NULL);

		ERROR
	}

	png_init_io       (png_ptr, fp);
	png_set_sig_bytes (png_ptr, HEADER_SIZE);
	png_read_info     (png_ptr, info_ptr);

	png_uint_32  width, height;
	int  bit_depth, color_type;
	
	png_get_IHDR
	(
		png_ptr, info_ptr, 
		& width, & height, & bit_depth, & color_type,
		NULL, NULL, NULL
	);

	if (8 != bit_depth)
	{
		ERROR
	}
	if (0 != color_type)
	{
		ERROR
	}

	size_t size = width ;
	size *= height ;

	unsigned char * M = malloc (size) ;

	png_bytep ps [height] ;
	ps [0] = M ;
	for (unsigned i = 1 ; i < height ; i++)
	{
		ps [i] = ps [i-1] + width ;
	}
	png_set_rows (png_ptr, info_ptr, ps);
	png_read_image (png_ptr, ps) ;

	printf 
	(
		"Image %s loaded:\n"
		"\twidth      = %lu\n"
		"\theight     = %lu\n"
		"\tbit_depth  = %u\n"
		"\tcolor_type = %u\n"
		, file_name, width, height, bit_depth, color_type
	) ;

	unsigned char * W = malloc (size) ;

	unsigned long long int sum = 0, start = 0, stop = 0;
	
	for(int i = 0; i < 20; i++){
		start = timer();
		filter (M, W, width, height) ;
		stop = timer();
		if(stop - start > 0)
			sum += stop - start;
		else
			sum += start - stop;
	}
	
	printf("Processor cycles per pixel: %llu\n", sum/(20*width*height));

	png_structp write_png_ptr =
		png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if (NULL == write_png_ptr)
	{
		ERROR
	}

	for (unsigned i = 0 ; i < height ; i++)
	{
		ps [i] += W - M ;
	}
	png_set_rows (write_png_ptr, info_ptr, ps);

	FILE *fwp = fopen ("out.png", "wb");
	if (NULL == fwp)
	{
		ERROR
	}

	png_init_io   (write_png_ptr, fwp);
	png_write_png (write_png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, NULL);
	fclose (fwp);

	return 0;
}

/*
 *	(i-1)*width+j		-1
 *	(i-1)*width+j+1		-1
 *	(i-1)*width+j+2		0
 *	i*width+j		-1
 *	i*width+j+1		0
 *	i*width+j+2		1
 *	(i+1)*width+j		0
 *	(i+1)*width+j+1		1
 *	(i+1)*width+j+2		1
 */


filter( unsigned char * M, unsigned char * W, int width, int height){
	/*
	 *	deklarujemy wektory 128 bitowe zawierajace liczby calkowite
	 *	bedziemy do nich wpisywac 16 bitowe wartosci
	 */ 
	__m128i result, vec1, vec2, vec3, vec4, vec5, vec6;
	for(int i = 1; i < height - 1; i++){
		for(int j = 8; j < width - 8; j+=8){
			/*
			 *	deklarujemy odpowiednie indeksy
			 */ 
			int cord1 = (i-1) * width + j;
			int cord2 = i * width + j;
			int cord3 = (i+1) * width + j;	
			/*
			 * 	Przypisanie odpowiednich
			 * 	wartosci do wektorow,
			 * 	0 mozna pominac
			 *
			 * 		       WYCINEK1	    WYCINEK2	 WYCINEK3     WYCINEK4	   WYCINEK5	WYCINEK6     WYCINEK7	  WYCINEK8
			 */
			/*
			vec1 = _mm_set_epi16(-M[cord1-8], -M[cord1-7], -M[cord1-6], -M[cord1-5], -M[cord1-4], -M[cord1-3], -M[cord1-2], -M[cord1-1]);
			vec2 = _mm_set_epi16(-M[cord1-7], -M[cord1-6], -M[cord1-5], -M[cord1-4], -M[cord1-3], -M[cord1-2], -M[cord1-1], -M[cord1]);
			vec3 = _mm_set_epi16(-M[cord2-8], -M[cord2-7], -M[cord2-6], -M[cord2-5], -M[cord2-4], -M[cord2-3], -M[cord2-2], -M[cord2-1]);
			vec4 = _mm_set_epi16( M[cord2-6],  M[cord2-5],  M[cord2-4],  M[cord2-3],  M[cord2-2],  M[cord2-1],  M[cord2]  ,  M[cord2+1]);
			vec5 = _mm_set_epi16( M[cord3-7],  M[cord3-6],  M[cord3-5],  M[cord3-4],  M[cord3-3],  M[cord3-2],  M[cord3-1],  M[cord3]);
			vec6 = _mm_set_epi16( M[cord3-6],  M[cord3-5],  M[cord3-4],  M[cord3-3],  M[cord3-2],  M[cord3-1],  M[cord3]  ,  M[cord3+1]);
			*/
			/*
			 *	_mm_loadu_si128((__m128i*) laduje do wektora 128 bity
			 *	_mm_cvtepu8_epi16 konwetuje unsigned byte na znakowane 16 bitow
			 */ 
			vec1 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord1 - 8]));
			vec2 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord1 - 7]));
			vec3 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord2 - 8]));
			vec4 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord2 - 6]));
			vec5 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord3 - 7]));
			vec6 = _mm_cvtepu8_epi16(_mm_loadu_si128((__m128i*)&M[cord3 - 6]));
			/*
			 *	zanegowanie pierwszych 3 wektorow, poniewaz mnozone sa przez -1
			 */ 
			vec1 =  _mm_sub_epi16(_mm_setzero_si128(), vec1);
			vec2 =  _mm_sub_epi16(_mm_setzero_si128(), vec2);
			vec3 =  _mm_sub_epi16(_mm_setzero_si128(), vec3);
			/*
			 *	zsumowanie wysztkich wektorow
			 *	i dodanie 765
			 */
			result = _mm_add_epi16(vec1, vec2);
			result = _mm_add_epi16(result, vec3);
	        	result = _mm_add_epi16(result, vec4);
        		result = _mm_add_epi16(result, vec5);
       			result = _mm_add_epi16(result, vec6);
			result = _mm_add_epi16(result, _mm_set1_epi16(765));
			/*
			 *	Mnozymy wynik przez 2731, poniewaz wartosc ta odpowiada wartosci
			 *	zmiennoprzecinkowej 1/6 (floating point to fixed point conversion)
			 */ 
			result = _mm_mulhrs_epi16(result, _mm_set1_epi16(2731)); 
			/*
			 *	przypisanie piksela o wlasciwej wartosci
			 */ 
			W[cord2 - 7] = _mm_extract_epi16(result, 0);
            		W[cord2 - 6] = _mm_extract_epi16(result, 1);
      		      	W[cord2 - 5] = _mm_extract_epi16(result, 2);
            		W[cord2 - 4] = _mm_extract_epi16(result, 3);
  			W[cord2 - 3] = _mm_extract_epi16(result, 4);
			W[cord2 - 2] = _mm_extract_epi16(result, 5);
            		W[cord2 - 1] = _mm_extract_epi16(result, 6);
            		W[cord2] = _mm_extract_epi16(result, 7);
			
		}
	}
}


