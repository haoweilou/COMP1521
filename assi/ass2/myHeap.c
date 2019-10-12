// COMP1521 19t2 ... Assignment 2: heap management system

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "myHeap.h"

/** minimum total space for heap */
#define MIN_HEAP 4096
/** minimum amount of space for a free Chunk (excludes Header) */
#define MIN_CHUNK 32

#define ALLOC 0x55555555
#define FREE  0xAAAAAAAA

#define TRUE 1
#define FALSE 0
/// Types:

typedef unsigned int  uint;
typedef unsigned char byte;

typedef uintptr_t     addr; // an address as a numeric type

/** The header for a chunk. */
typedef struct header {
	uint status;    /**< the chunk's status -- ALLOC or FREE */
	uint size;      /**< number of bytes, including header */
	byte data[];    /**< the chunk's data -- not interesting to us */
} header;

/** The heap's state */
struct heap {
	void  *heapMem;     /**< space allocated for Heap */
	uint   heapSize;    /**< number of bytes in heapMem */
	void **freeList;    /**< array of pointers to free chunks */
	uint   freeElems;   /**< number of elements in freeList[] */
	uint   nFree;       /**< number of free chunks */
};


/// Variables:

/** The heap proper. */
static struct heap Heap;


/// Functions:

static addr heapMaxAddr (void);
void updatefreelist(void);


/** Initialise the Heap. */
int initHeap (int size)
{
	Heap.nFree = 0;
	Heap.freeElems = 0;
	
	/// TODO ///
	//calculate the size of heap
	if(size < 0) return -1;
	else if(size < MIN_HEAP) Heap.heapSize = MIN_HEAP;
	else {
		if(size%4 == 0) Heap.heapSize = size;
		else Heap.heapSize = size-size%4 + 4;
	}
	//create a header to store the big free chunk
	header *newheader = malloc(Heap.heapSize);
	newheader->status = FREE;
	newheader->size = Heap.heapSize;
	//link the heap memory to first byte
	Heap.heapMem = (addr *)newheader;
	Heap.nFree = 1;
	//point free list to the head of big chunk
	Heap.freeElems = Heap.heapSize/MIN_CHUNK;
	Heap.freeList = malloc(sizeof(Heap.freeList)*Heap.freeElems);
	updatefreelist();
	return 0; // this just keeps the compiler quiet
}

/** Release resources associated with the heap. */
void freeHeap (void)
{
	free (Heap.heapMem);
	free (Heap.freeList);
}

/** Allocate a chunk of memory large enough to store `size' bytes. */
void *myMalloc (int size)
{
	/// TODO ///
	if(size < 1) return NULL;
	if(size%4 != 0) size = size - size%4 + 4;
	//find the size need for size and header
	uint size_header = size + sizeof(header);
	header *min = Heap.freeList[0];
	for(int i = 0; i < Heap.nFree; i++) {
		header *curr = (header *) Heap.freeList[i];
		if (curr->size > size_header) {
			min = curr;
			break;
		}
	}

	for(int i = 0; i < Heap.nFree; i++){
		header *curr = (header *) Heap.freeList[i];
		if (min->size > curr->size && curr->size > size_header) min = curr;
	}
	if(min->size < size_header) return NULL;
	min->status = ALLOC;
	int chunk_size = min->size;
	if(min->size >= size_header + MIN_CHUNK)
	{
		min->size = size_header;
		addr curr = (addr)min + min->size;
		header *next = (header *)curr;
		next->status = FREE;
		next->size = chunk_size - min->size;
	}
	updatefreelist();

	return min->data;
}

/** Deallocate a chunk of memory. */
void myFree (void *obj)
{
	/// TODO ///
	int offset = heapOffset(obj);
	addr curr = (addr) Heap.heapMem;
	int finish_free = FALSE;
	header *chunk = (header *)curr;
	while(finish_free == FALSE){
		chunk = (header *)curr;
		int curr_offest = heapOffset(chunk->data);
		if(offset == curr_offest && chunk->status == ALLOC){
			chunk->status = FREE;
			break;
		}
		curr = (addr)curr + chunk->size;
	}
	curr = (addr)Heap.heapMem;
	chunk = (header *)curr;
	header *next = (header *)(curr + chunk->size);
	while(heapOffset((addr *)curr) < Heap.heapSize){
		chunk = (header *)curr;
		next = (header *)((addr)curr + chunk->size);
		if(next->status == FREE && chunk->status == FREE) chunk->size += next->size;
		else curr = (addr)curr + chunk->size;
	}
	updatefreelist();
	return;
}

/** Return the first address beyond the range of the heap. */
static addr heapMaxAddr (void) 
{
	return (addr) Heap.heapMem + Heap.heapSize;
}

/** Convert a pointer to an offset in the heap. */
int heapOffset (void *obj)
{
	addr objAddr = (addr) obj;
	addr heapMin = (addr) Heap.heapMem;
	addr heapMax =        heapMaxAddr ();
	if (obj == NULL || !(heapMin <= objAddr && objAddr < heapMax))
		return -1;
	else
		return (int) (objAddr - heapMin);
}

/** Dump the contents of the heap (for testing/debugging). */
void dumpHeap (void)
{
	int onRow = 0;

	// We iterate over the heap, chunk by chunk; we assume that the
	// first chunk is at the first location in the heap, and move along
	// by the size the chunk claims to be.
	addr curr = (addr) Heap.heapMem;
	while (curr < heapMaxAddr ()) {
		header *chunk = (header *) curr;
		char stat;
		switch (chunk->status) {
		case FREE:  stat = 'F'; break;
		case ALLOC: stat = 'A'; break;
		default:
			fprintf (
				stderr,
				"myHeap: corrupted heap: chunk status %08x\n",
				chunk->status
			);
			exit (1);
		}

		printf (
			"+%05d (%c,%5d)%c",
			heapOffset ((void *) curr),
			stat, chunk->size,
			(++onRow % 5 == 0) ? '\n' : ' '
		);

		curr += chunk->size;
	}

	if (onRow % 5 > 0)
		printf ("\n");
}

void updatefreelist()
{
	addr curr = (addr)Heap.heapMem;
	header *chunk;
	int i = 0;
	while(heapOffset((addr *)curr) < Heap.heapSize){
		chunk = (header *)curr;
		if(chunk->status == FREE){
			Heap.freeList[i] = (addr *)curr;
			i++;
		}
		Heap.nFree = i;
		curr = (addr)curr + chunk->size;
	}
}