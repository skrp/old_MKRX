/*	
 * slicr
 *
 * Shred a file into random parts
 * Store the part-listing as a qui file
 *
 * ARG2 - FILE
 * ARG3 - DUMP DIR
 * ARG4 - QUI DIR
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <sha256.h>
#include <sys/stat.h>
// GLOBAL
#define SHA256_DIGEST_LENGTH 32
#define FILE_STEP 1024
// USAGE
static void usage()
{
	fprintf(stderr, "usage:	slicr file path_to_dump path_to_qui\n");
	exit(1);
}
// RECOMPILE QUI TO FILE = dp
// CHUNK FILE = sp 
int push(char * chunk_file, const char * dest_file)
{	
// OPEN FILES
	FILE *sp, *dp;
	sp = fopen(chunk_file, "rb");
	dp = fopen(dest_file, "a");
	if (sp == NULL)
	{
		printf("Problem opening chunk file\n");
		return 1;
	}
	if (dp == NULL)
	{
		printf("Problem opening recompiling file\n");
		return 1;
	}
// CHUNK SIZE = f_size
	fseek(sp, 0, SEEK_END);
	long f_size = ftell(sp);
	fseek(sp, 0, SEEK_SET);

	long position = 0;
///////////////////////////////////////////////////////////////
// ITERATE ON BUFFER BY FILE_STEP = size
	while (position + 1 < f_size)
	{
		long size = FILE_STEP;
		if (position + size >= f_size)
		{
			size = f_size - position;
		}
// BUFFER
		char *buffer = malloc(size);
		if (buffer == NULL)
		{
			fprintf(stderr, "memory error\n");
			fclose(sp);
			fclose(dp);
			return 1;
		}
		
		position += size;
// TEST SIZE INTEGRITY = read_size
		size_t read_size = fread(buffer, 1, (size_t) size, sp);
		if (read_size != size)
		{
			fprintf(stderr, "read error\n");
			fclose(sp);
			fclose(dp);
			return 1;
		}
// CONCATENATE
		fwrite(buffer, 1, (size_t) size, dp);
		free(buffer);
	}
/////////////////////////////////////////////////////////////////
	fclose(sp);
	fclose(dp);
	return 0;
}	

//###############################################################
// BEGIN
int main(int argc, char *argv[])
{
	int i = 0;
// TEST ARGS
	if (argc != 4)
	{
		usage();
	}
// OPEN FILES = fp
	FILE *fp, *mfp;
	fp = fopen(argv[1], "rb");
	if (fp == NULL)
	{
		printf("Problem opening file\n");
		exit(1);
	}
// TEST DIRS 
	struct stat st_dump;
	if (stat(argv[2], &st_dump) != 0)
	{
		printf("Problem with dump dir\n");
		fclose(fp);
		exit(1);
	}
	if (stat(argv[2], &st_dump) != 0)
	{
		printf("Problem with dump dir\n");
		fclose(fp);
		exit(1);
	}
// SEED RAND
	srand((unsigned int) time(NULL));
// COMPELTE FILE SIZE = f_size
	fseek(fp, 0, SEEK_END);
	long f_size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	long position = 0;
// COMPLETE FILE HASH = file_hash
	char * file_hash = SHA256_File(argv[1], NULL);
// QUI FILE PATH = qui_file_path	
	char *qui_file_path = malloc(strlen(argv[3]) + strlen(file_hash) +1);
	strcpy(qui_file_path, argv[3]);
	if (qui_file_path[strlen(qui_file_path) - 1] != '/')
	{
		strcat(qui_file_path, "/");
	}	
	strcat(qui_file_path, file_hash);
// CREATE QUI FILE
	mfp = fopen(qui_file_path, "w");
	if (mfp == NULL)
	{
		printf("Problem with opening qui file\n");
		fclose(fp);
		exit(1);
	}
/////////////////////////////////////////////////////////////////
// SLICR
	while (position + 1 < f_size)
	{
// RAND-NUMB = size
		long size = rand() % 1000000;	
		if (position + size >= f_size)
		{
			size = f_size - position;
		}
// BUFFER
		char *buffer = malloc(size);
		if (buffer == NULL)
		{
			fprintf(stderr, "memory error\n");
			fclose(fp);
			fclose(mfp);
			exit(1);
		}

// TEST SIZE INTEGRITY
		size_t read_size = fread(buffer, 1, (size_t) size, fp);
		if (read_size != size)
		{
			fprintf(stderr, "read error\n");
			fclose(fp);
			fclose(mfp);
			exit(1);
		}
// PARTIAL FILE SHA = chunk_hash
		char * chunk_hash = SHA256_FileChunk(argv[1], NULL, position, size);
// SET DUMP PATH
		char *dump_file_path = malloc(strlen(argv[2]) + strlen(chunk_hash) + 1);
		strcpy(dump_file_path, argv[2]);
		if (dump_file_path[strlen(dump_file_path) - 1] != '/')
		{
			strcat(dump_file_path, "/");
		}
		strcat(dump_file_path, chunk_hash);
//
		FILE *wfp;
		wfp = fopen(dump_file_path, "w");
		free(dump_file_path);
	
		if (wfp == NULL)
		{
			printf("Problem opening dump file\n");
			fclose(fp);
			fclose(mfp);
			exit(1);
		}
		fwrite(buffer, 1, (size_t) size, wfp);
		free(buffer);
		fclose(wfp);
	
		fwrite(chunk_hash, 1, 2 * SHA256_DIGEST_LENGTH, mfp);
		fwrite("\n", 1, 1, mfp);
		free(chunk_hash);
		position += size;
	}
//////////////////////////////////////////////////////////////
	fclose(fp);
	fclose(mfp);
// 
	mfp = fopen(qui_file_path, "rb");
	free(qui_file_path);
	if (mfp == NULL)
	{
		printf("Problem opening qui file\n");
		exit(1);
	}
// EXPERIMENT = tmp_file
	char *tmp_file = malloc(strlen(argv[2]) + 10);
	strcpy(tmp_file, argv[2]);
	if (tmp_file[strlen(tmp_file) - 1] != '/')
	{
		strcat(tmp_file, "/");
	}
	strcat(tmp_file, "tmp_copy");
// CREATE EXPERIMENT FILE
	fp = fopen(tmp_file, "w");
	if (fp == NULL)
	{
		printf("Problem opening tmp file\n");
		exit(1);
	}
	fclose(fp);
	
	size_t len;
	char *chunk_fname;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// RECOMPILE FILE
	while ((chunk_fname = fgetln(mfp, &len)) != NULL)
	{
// SANITIZE DATA = chunk_fname
		if (chunk_fname[len -1] == '\n')
		{
			chunk_fname[len -1] = '\0';
		}
		char *chunk_file = malloc(strlen(argv[2]) + strlen(chunk_fname) + 1);
		strcpy(chunk_file, argv[2]);
		if (chunk_file[strlen(chunk_file) - 1] != '/')
		{
			strcat(chunk_file, "/");
		}
		strcat(chunk_file, chunk_fname);
// PUSH FN
		if (push(chunk_file, tmp_file) != 0)
		{
			exit(1);
		}
		free(chunk_file);
	}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	fclose(mfp);

// INTEGRITY CHECK
	char *tmp_hash = SHA256_File(tmp_file, NULL);
	if (strcmp(tmp_hash, file_hash) != 0)
	{
		printf("INTEGRITY ISSUE : %s\n", argv[1]);
	}
// CLEAN UP
	free(tmp_hash);
	remove(tmp_file);
	free(tmp_file);
	free(chunk_fname);
	free(file_hash);
	return 0;
}
//###############################################################
