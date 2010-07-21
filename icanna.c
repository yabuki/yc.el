/* icanna.c
 * VERSION: 0.9.0
 * AUTHER: knak@ceres.dti.ne.jp
 * DATE: 2003.9.29
 * LICENCE: GPL
 */

/*
 * communicate unix domain cannaserver
 * stdin -> cannaserver -> stdout
 */
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <sys/un.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

#define BFSZ (4096)	/* buffer size */
#define CANNA_PATH ("/tmp/.iroha_unix/IROHA")	/* unix domain socket path */

/*
 * connect unix domain cannaserver
 */
int
connect_canna_server()
{
  int canna;
  struct sockaddr_un sun;

  /* create unix domain socket */
  if ((canna = socket(PF_UNIX, SOCK_STREAM, 0)) < 0) {
    perror("socket");
    exit(1);
  }
  /* connect cannaserver */
  sun.sun_family = AF_UNIX;
  strcpy(sun.sun_path, CANNA_PATH);
  if (connect(canna, (struct sockaddr*)&sun, SUN_LEN(&sun)) < 0) {
    perror("connect");
    exit(1);
  }
  return canna;
}

/*
 * data transport
 * stdin -> canna
 * canna -> stdout
 */
int
transport(in, out)
int in, out;
{
  char* buf = NULL;	/* data buffer */
  int len = BFSZ;	/* data length */
  int count = -1;	/* read count */

  /* read input */
  while (len == BFSZ) {
    count++;
    /* allocate data buffer */
    if ((buf = (char*)realloc(buf, (count + 1) * BFSZ)) == NULL) {
      perror("realloc");
      exit(1);
    }
    /* read input to data buffer */
    if ((len = read(in, buf + count * BFSZ, BFSZ)) < 0) {
      perror("read");
      exit(1);
    }
  }
  len += count * BFSZ;
  /* write output */
  if (len > 0 && write(out, buf, len) < 0) {
    perror("write");
    exit(1);
  }
  /* destroy data buffer */
  free(buf);
  return len;
}

/*
 * communicate unix domain cannaserver
 */
int
main()
{
  int canna;
  
  canna = connect_canna_server();	/* connect unix domain cannaserver */

  /* transport request & response, until stdin or cannaserver is eof */
  while (1)
    /* transport request from stdin to cannaserver,
     * transport response from cannaserver to stdout */
    if (transport(0, canna) == 0 || transport(canna, 1) == 0)
      /* when stdin or cannaserver is eof, break loop */
      break;
  close(canna);	/* close unix domain cannaserver */
  return 0;
}
