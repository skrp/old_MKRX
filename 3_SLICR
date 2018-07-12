//#####################################
// SLICR - shred file into random-sized blocks
//       - verify the file afterword is costly
//       - run this to check new system only
//
// FreeBSD-kernel-only
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <sha256.h>
#include <sys/stat.h>
#include <sys/types.h>
// GLOBAL
#define SHALEN 65
#define SIZE 1000000 // 1B -> 1MB
// USAGE
static void usage()
  { printf("usage: SLICR target_file dump_path key_path\n"); exit(1); }
int build(char *f_block, char *v_file);
// BEGIN ##############################
int main(int argc, char *argv[])
{
// ARG CHK
  if (argc != 4)
    { usage(); }
  struct stat st_dump;

  if (stat(argv[2], &st_dump) != 0)
    { printf("FAIL dump_path %s", argv[2]); exit(1); }
  if (stat(argv[3], &st_dump) != 0)
    { printf("FAIL key_path %s", argv[3]); exit(1); }
// DECLARE 
  FILE *fp, *kfp, *kkfp;
  
  unsigned long long int f_size, position = 0;

  char *key_path, *dump_path;
  char *f_sha, *v_sha;
  char *f_key, *v_file;
  char k_line[66];
  
  size_t len; 
// SANITIZE
  dump_path = malloc(strlen(argv[2]) + 100);
  strcpy(dump_path, argv[2]);
  if (dump_path[strlen(dump_path) - 1] != '/')
    { strcat(dump_path, "/"); }

  key_path = malloc(strlen(argv[3] + 100);
  strcpy(key_path, argv[3]);)
  if (key_path[strlen(key_path) - 1] != '/')
    { strcat(key_path, "/"); }
// TARGET FILE
  if ((fp = fopen(argv[1], "rb")) < 0) 
    { printf("FAIL fopen(fp) at%s\n", argv[1]); }

  fseek(fp, 0, SEEK_END);
  f_size = ftell(fp);
  fseek(fp, 0, SEEK_SET);
  f_sha = SHA256_File(argv[1], NULL);
// KEY FILE
  f_key = malloc(strlen(argv[3]) + 100);
  strcpy(f_key, key_path);
  strcat(f_key, f_sha);

  if ((kfp = fopen(f_key, "wb")) < 0)
    { printf("FAIL fopen(f_key) at: %s\n", argv[3]); exit(1); }
// SLICE //////////////////////////////
  while (position < f_size)
  {
// DECLARE
    FILE *bbfp;
    uint32_t size, read_size;
    char *buf, *b_sha, *ff_block;
// block SIZE 
    size = arc4random((uint32_t) SIZE);
    if (size == 0)
      { continue; }

    if (position + size >= f_size)
      { size = f_size - position; }
    
    if ((buf = malloc(size)) == NULL)
      { printf("FAIL memory buf pos: %llu\n", position); exit(1); }
// write block
    if ((read_size = fread(buf, 1, (size_t) size, fp)) != size)
      { printf("FAIL read mismatch size: %u read_size: %u\n", size, read_size); exit(1); }
// sha block
    b_sha = SHA256_FileChunk(argv[1], NULL, (off_t) position, (off_t) size);
    ff_block = malloc(strlen(argv[2]) + 100);
    strcpy(ff_block, dump_path);
    strcat(ff_block, b_sha);

    if ((bbfp = fopen(ff_block, "wb")) < 0)
      { printf("FAIL ff_block open pos: %llu\n", position); exit(1); }

    if ((fwrite(buf, 1, (size_t) size, bbfp)) != size)
      { printf("FAIL write block: %llu \n", position); exit(1); }
// write key
    fwrite(b_sha, 1, 64, kfp);
    fwrite("\n", 1, 1, kfp);

   // printf("%s %s %llu\n", f_key, b_sha, position);
    position += size;
///////////////////////////////////////
// cleanup
    free(buf); free(b_sha); free(ff_block); 
    fclose(bbfp);
  }

  fclose(kfp);
// VERIFICATION BUILD &&&&&&&&&&&&&&&&&
  v_file = malloc(strlen(argv[3]) + 10);
  strcpy(v_file, key_path);
  strcat(v_file, "tmp"); 

  if ((kkfp = fopen(f_key, "rb")) < 0)
    { printf("FAIL fopen(f_key) at: %s\n", f_key); exit(1); }

  unlink(v_file); // remove previous tmp-file
// build verification-file
  while(fgets(k_line, 66, kkfp) != NULL)
  {
    if (k_line[strlen(k_line) - 1] =='\n')
      { k_line[strlen(k_line) - 1] = '\0'; }

    char *fff_block = malloc(strlen(argv[2]) + 100);
    strcpy(fff_block, dump_path);
    strcat(fff_block, k_line); 
// FN 
    if ((build(fff_block, v_file)) < 0) 
      { printf("FAIL push(v_file) at: %s\n", f_key); exit(1); }
    
    free(fff_block);
  }
// INTEGRITY CHK
  v_sha = SHA256_File(v_file, NULL);
  if ((strcmp(f_sha, v_sha)) != 0)
    { printf("FAIL VERIFICATION with %s bad: %s\n", f_key, v_sha); exit(1); }
  printf("f: %s v: %s\n", f_sha, v_sha);
// cleanup
  fclose(fp); fclose(kkfp);
  free(key_path); free(dump_path); 
  free(f_key); free(v_file);
  free(f_sha); free(v_sha);
  return 0;
}
// FN #################################
int build(char *f_block, char *v_file)
{
  FILE *vfp, *bfp;
  unsigned long int b_size, writ_size;
  char *buf;
// verification file
  if ((vfp = fopen(v_file, "ab")) < 0)
    { printf("FAIL fopen(v_file) at: %s\n",v_file); exit(1); }
// block file 
  if ((bfp = fopen(f_block, "rb")) < 0)
    { printf("FAIL fopen(f_block) at: %s\n",f_block); exit(1); }

  fseek(bfp, 0, SEEK_END);
  b_size = ftell(bfp);
  fseek(bfp, 0, SEEK_SET);

  if ((buf = malloc(b_size)) == NULL) 
    { printf("FAIL out of memory buf b_size: %lu\n", b_size); exit(1); }
// read block-file
  if ((writ_size = fread(buf, 1, (size_t) b_size, bfp)) != b_size)
    { printf("FAIL write size mismatch b_size: %lu writ_size: %lu\n", b_size, writ_size); exit(1); }

// write verification-file
  if ((fwrite(buf, 1, (size_t) b_size, vfp)) != b_size)
    { printf("FAIL write v_fp: %s \n", v_file); exit(1); }

// cleanup
  fclose(vfp); fclose(bfp);
  free(buf);

  return 0;
}
