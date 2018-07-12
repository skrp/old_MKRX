///////////////////////////////////////////
// BUILD - take a batch of key-files to build from a block-pool
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sha256.h>
#include <sys/stat.h>
#include <sys/types.h>
// GLOBAL
#define SHALEN 66
#define SIZE 1000000 // 1B -> 1MB
#define MAX 10000 // list
// USAGE
static void usage()
  { printf("usage: BLKR key_list key_path block_path dump_path\n"); exit(1); }
int build(char *target_file, char *block_path, char *dump_path);
int main(int argc, char *argv[])
{
// ARG CHK
  struct stat st_dump;
  char *target_list, *key_path, *block_path, *dump_path, *target_file;

  if (argc != 5)
    { usage(); }

  if (stat(argv[2], &st_dump) != 0)
    { printf("FAIL key_path %s", argv[2]); exit(1); }
  if (stat(argv[3], &st_dump) != 0)
    { printf("FAIL block_path %s", argv[3]); exit(1); }
  if (stat(argv[4], &st_dump) != 0)
    { printf("FAIL dump_path %s", argv[4]); exit(1); }

// SANITIZE
  key_list = malloc(strlen(argv[1] + SHALEN));
  key_path = malloc(strlen(argv[2] + SHALEN));
  block_path = malloc(strlen(argv[3] + SHALEN));
  dump_path = malloc(strlen(argv[4] + SHALEN));

  strcpy(key_list, argv[1]);
  strcpy(key_path, argv[2]);
  strcpy(block_path, argv[3]);
  strcpy(dump_path, argv[4]);

  if (target_path[strlen(key_path) - 1] != '/')
    { strcat(key_path, "/"); }
  if (dump_path[strlen(block_path) - 1] != '/')
    { strcat(block_path, "/"); }
  if (key_path[strlen(dump_path) - 1] != '/')
    { strcat(dump_path, "/"); }

// LIST ###############################
  FILE *lfp;
  char list_line[66];
  
  if ((lfp = fopen(key_list, "rb")) < 0)
    { printf("FAIL fopen(fp) at: %s\n", key_list); }

  while (fgets(list_line, 66, lfp) != NULL)
  {
    if (list_line[strlen(list_line) - 1] == '\n')
      { list_line[strlen(list_line) - 1] = '\0'; }

// WORK LIST ##########################
    target_file = malloc(strlen(target_path) + 66);
    strcpy(target_file, key_path);
    strcat(target_file, list_line);
// ACTION
    if ((build(target_file, block_path, dump_path)) < 0)
      { printf("FAIL build target: %s block: %s dump: %s\n", target_file, block_path, dump_path); }
//  cleanup
    free(target_file);
  }
  free(target_path); free(key_path); free(block_path); free(dump_path); free(target_list);
}

int build(char *target_file, char *block_path, char *dump_path)
{
  FILE *vfp, *bfp;
  unsigned long int b_size, writ_size;
  char *buf, *v_file;
// verification file
  v_file = malloc(strlen(dump_path + SHALEN));
  strcpy(v_file, dump_path);
  strcat(vfile, "tmp");
    
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
