// mysh.c ... a minimal shell
// Started by John Shepherd, October 2017
// Completed by <<YOU>>, July 2019

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>

#include <assert.h>
#include <ctype.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DEFAULT_PATH "/bin:/usr/bin"
#define DBUG
#define TRUE 1
#define FALSE 0
#define MAX 1024

static void execute (char **, char **, char **);
static bool isExecutable (char *);
static char **tokenise (const char *, const char *);
static void freeTokens (char **);
static char *trim (char *);
static size_t strrspn (const char *, const char *);


// Environment variables are pointed to by `environ', an array of
// strings terminated by a NULL value -- something like:
//     { "VAR1=value", "VAR2=value", NULL }
extern char **environ;

int main (int argc, char *argv[])
{
	// grab the `PATH' environment variable;
	// if it isn't set, use the default path defined above
	char *pathp;
	if ((pathp = getenv ("PATH")) == NULL)
		pathp = DEFAULT_PATH;
	char **path = tokenise (pathp, ":");

	// main loop: print prompt, read line, execute command
	char line[BUFSIZ];
	printf ("mysh$ ");
	while (fgets (line, BUFSIZ, stdin) != NULL) {
		trim (line); // remove leading/trailing space
		if (strcmp (line, "exit") == 0) break;
		if (strcmp (line, "") == 0) { printf ("mysh$ "); continue; }

		pid_t pid;   // pid of child process
		int stat;	 // return status of child

		/// TODO: implement the `tokenise, fork, execute, cleanup' code
		//tokenise the command line
        char **arguments = tokenise(line," ");
		if(strcmp(arguments[0],"cd") == 0){
			chdir(arguments[1]);
			printf("$mysh ");
			continue;
		} else if(strcmp(arguments[0],"pwd") == 0){
			char buffer[MAX] = {0};
			getcwd(buffer,MAX);
			printf("%s\n",buffer);
			printf("$mysh ");
			continue;
		}
		//fork a copy
        pid = fork();
		//child process invokes execute
		if(pid == 0)
			execute(arguments,path,environ);
		else {
			wait(&stat);
		}
		freeTokens (arguments);
		printf("mysh$ ");
	}
	freeTokens (path);

	return EXIT_SUCCESS;
}

// execute: run a program, given command-line args, path and envp
static void execute (char **args, char **path, char **envp)
{
	/// TODO: implement the `find-the-executable and execve(3) it' code
	int find = FALSE;
	char *command;
	if(args[0][0] == '/' || args[0][0] == '.'){
        if(isExecutable(args[0]) == TRUE){
			command = args[0];
			find = TRUE;
        }
    } else {
		for(int i = 0; path[i] != NULL; i++){
			char *buffer = path[i];
			strcat(buffer,"/");
			strcat(buffer,args[0]);
			if(isExecutable(buffer) == TRUE){
				find = TRUE;
				command  = buffer;
				break;
			}
		}
	}

	
	if(find == FALSE) {
		printf("%s: command not found\n",args[0]);
	} else {
		printf("Executing %s\n",command);
		execve(command,args,envp);
		exit(1);
	}
	return;
}

/// isExecutable: check whether this process can execute a file
static bool isExecutable (char *cmd)
{
	struct stat s;
	// must be accessible
	if (stat (cmd, &s) < 0) return false;
	// must be a regular file
	if (! S_ISREG (s.st_mode)) return false;
	// if it's owner executable by us, ok
	if (s.st_uid == getuid () && s.st_mode & S_IXUSR) return true;
	// if it's group executable by us, ok
	if (s.st_gid == getgid () && s.st_mode & S_IXGRP) return true;
	// if it's other executable by us, ok
	if (s.st_mode & S_IXOTH) return true;
	// otherwise, no, we can't execute it.
	return false;
}

/// tokenise: split a string around a set of separators
/// create an array of separate strings
/// final array element contains NULL
static char **tokenise (const char *str_, const char *sep)
{
	char **results  = NULL;
	size_t nresults = 0;

	// strsep(3) modifies the input string and the pointer to it,
	// so make a copy and remember where we started.
	char *str = strdup (str_);
	char *tmp = str;

	char *tok;
	while ((tok = strsep (&str, sep)) != NULL) {
		// "push" this token onto the list of resulting strings
		results = realloc (results, ++nresults * sizeof (char *));
		results[nresults - 1] = strdup (tok);
	}

	results = realloc (results, ++nresults * sizeof (char *));
	results[nresults - 1] = NULL;

	free (tmp);
	return results;
}

/// freeTokens: free memory associated with array of tokens
static void freeTokens (char **toks)
{
	for (int i = 0; toks[i] != NULL; i++)
		free (toks[i]);
	free (toks);
}

/// trim: remove leading and trailing whitespace from a string
static char *trim (char *str)
{
	char *space = " \r\n\t";
	str[strrspn (str, space) + 1] = '\0'; // skip trailing whitespace
	str = &str[strspn (str, space)];      // skip leading whitespace
	return str;
}

/// strrspn: find a suffix substring made up of any of `set'.
/// like `strspn(3)', except from the end of the string.
static size_t strrspn (const char *str, const char *set)
{
	size_t len;
	for (len = strlen (str); len != 0; len--)
		if (strchr (set, str[len]) == NULL)
			break;
	return len;
}
