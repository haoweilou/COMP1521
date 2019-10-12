// COMP1521 18s1 Q2 ... addStudent() function
// - insert a Student record into a file in order

#include "Students.h"
#include"stdio.h"
#include <unistd.h>
#include"stdlib.h"
// put any other required #include's here

void addStudent(int fd, Student stu)
{
	// your code goes here
	Student curr;
	int numStu = 0;
	//int i = 0;
	while (read(fd, &curr, sizeof(Student)))
	{
		numStu++;
	}
	lseek(fd,0,SEEK_SET);
	int i = 0;
	while (read(fd, &curr, sizeof(Student)))
	{
		if(stu.id < curr.id)
		{
			break;
		}
		i++;
	}
	int k = numStu;
	for(k = numStu; k > i; k--)
	{
		lseek(fd,(k-1)*sizeof(Student),SEEK_SET);
		read(fd, &curr, sizeof(Student));
		lseek(fd,k*sizeof(Student),SEEK_SET);
		write(fd,&curr,sizeof(Student));
	}
	lseek(fd, i*sizeof(Student), SEEK_SET);
	write(fd,&stu,sizeof(Student));
}
