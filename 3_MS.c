//#####################################
// MS - mulitSLICR - shred file into randome parts without verification cost
//                 - the file can be verified later over time, audits over over-resource-consumption
//                 - this code will be acceptable until an error is found
// FreeBSD - unix is hacker all else is hack
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <sha256.h>
#include <sys/stat.h>
#include <sys/types.h>
// GLOBAL
#define SHALEN 66
#define SIZE 1000000 // 1B -> 1MB
#define MAX 10000 // list

static void usage() { printf("usage: SLICR target_list target_path dump_path key_path\n"); exit(1); }

int slicr(char *target_file, char *dump_path, char *key_path);
int build(char *f_block, char *v_file);

int main(int argc, char *argv[])
{
  struct stat st_dump;
  char *target_list, *target_path, *dump_path, *key_path, *target_file;
  arg_chk();

  target_list = malloc(strlen(argv[1] + SHALEN)); strcpy(target_list, argv[1]);
  target_path = malloc(strlen(argv[2] + SHALEN)); strcpy(target_path, argv[2]); if (target_path[strlen(target_path) - 1] != '/') { strcat(target_path, "/"); }
  dump_path = malloc(strlen(argv[3] + SHALEN)); strcpy(dump_path, argv[3]); if (dump_path[strlen(dump_path) - 1] != '/') { strcat(dump_path, "/"); }
  key_path = malloc(strlen(argv[4] + SHALEN)); strcpy(key_path, argv[4]); if (key_path[strlen(key_path) - 1] != '/') { strcat(key_path, "/"); }
// LIST ###############################
  FILE *lfp;
  char list_line[SHALEN];

  if ((lfp = fopen(target_list, "rb")) < 0) { printf("FAIL fopen(fp) at: %s\n", target_list); }
  while (fgets(list_line, SHALEN, lfp) != NULL)
  {
    if (list_line[strlen(list_line) - 1] == '\n') { list_line[strlen(list_line) - 1] = '\0'; }
// WORK LIST ##########################
    target_file = malloc(strlen(target_path) + SHALEN);
    strcpy(target_file, target_path);
    strcat(target_file, list_line);
// ACTION
    slicr(target_file, dump_path, key_path);
//  cleanup
    free(target_file);
  }
  free(target_path); free(dump_path); free(key_path); free(target_list);
}
// slicr ##############################
int slicr(char *target_file, char *dump_path, char *key_path)
{
// DECLARE
  FILE *fp, *kfp, *kkfp;
  unsigned long long int f_size, position = 0;
  char *f_sha, *v_sha; char *f_key, *v_file;
  char k_line[SHALEN];
// TARGET FILE
  if ((fp = fopen(target_file, "rb")) < 0) { printf("FAIL fopen(fp) at%s\n", target_file); }
// FILE SIZE
  fseek(fp, 0, SEEK_END); f_size = ftell(fp); fseek(fp, 0, SEEK_SET);
// SHA
  f_sha = SHA256_File(target_file, NULL);
// KEY FILE
  f_key = malloc(strlen(key_path) + 100);
  strcpy(f_key, key_path);
  strcat(f_key, f_sha);
  if ((kfp = fopen(f_key, "wb")) < 0) { printf("FAIL fopen(f_key) at: %s\n", key_path); exit(1); }

  while (position < f_size)
  {
// SLICE //////////////////////////////
    FILE *bbfp;
    uint32_t size, read_size;
    char *buf, *b_sha, *ff_block;

    size = arc4random((uint32_t) SIZE); if (size == 0) { continue; }

    if (position + size >= f_size) { size = f_size - position; }

    if ((buf = malloc(size)) == NULL) { printf("FAIL memory buf pos: %llu\n", position); exit(1); }

    if ((read_size = fread(buf, 1, (size_t) size, fp)) != size) { printf("FAIL read mismatch size: %u read_size: %u\n", size, read_size); exit(1); }

    b_sha = SHA256_FileChunk(target_file, NULL, (off_t) position, (off_t) size);

    ff_block = malloc(strlen(dump_path) + SHALEN); strcpy(ff_block, dump_path); strcat(ff_block, b_sha);

    if ((bbfp = fopen(ff_block, "wb")) < 0) { printf("FAIL ff_block open pos: %llu\n", position); exit(1); }

    if ((fwrite(buf, 1, (size_t) size, bbfp)) != size) { printf("FAIL write block: %llu \n", position); exit(1); }

    fwrite(b_sha, 1, 64, kfp); fwrite("\n", 1, 1, kfp);

    position += size;
///////////////////////////////////////
// cleanup
    free(buf); free(b_sha); free(ff_block);
    fclose(bbfp);
  }
  fclose(fp); fclose(kfp);
  free(f_key); free(f_sha);
  return 0;
}
// arg_chk ############################
void arg_chk()
{
  if (argc != 5) { usage(); }

  if (stat(argv[2], &st_dump) != 0) { printf("FAIL target_path %s", argv[2]); exit(1); }
  if (stat(argv[3], &st_dump) != 0) { printf("FAIL dump_path %s", argv[3]); exit(1); }
  if (stat(argv[4], &st_dump) != 0) { printf("FAIL key_path %s", argv[4]); exit(1); }
}
