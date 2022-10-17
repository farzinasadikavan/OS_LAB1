
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 55 11 80       	mov    $0x80115570,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 33 10 80       	mov    $0x80103320,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 74 10 80       	push   $0x80107460
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 35 46 00 00       	call   80104690 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 74 10 80       	push   $0x80107467
80100097:	50                   	push   %eax
80100098:	e8 c3 44 00 00       	call   80104560 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 77 47 00 00       	call   80104860 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 99 46 00 00       	call   80104800 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 44 00 00       	call   801045a0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 0f 24 00 00       	call   801025a0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 74 10 80       	push   $0x8010746e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 7d 44 00 00       	call   80104640 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 c7 23 00 00       	jmp    801025a0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 74 10 80       	push   $0x8010747f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 44 00 00       	call   80104640 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 43 00 00       	call   80104600 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 40 46 00 00       	call   80104860 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 8f 45 00 00       	jmp    80104800 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 74 10 80       	push   $0x80107486
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 87 18 00 00       	call   80101b20 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 c0 ef 10 80 	movl   $0x8010efc0,(%esp)
801002a0:	e8 bb 45 00 00       	call   80104860 <acquire>
  while (n > 0)
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
  {
    while (input.r == input.w)
801002b0:	a1 a0 ef 10 80       	mov    0x8010efa0,%eax
801002b5:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 c0 ef 10 80       	push   $0x8010efc0
801002c8:	68 a0 ef 10 80       	push   $0x8010efa0
801002cd:	e8 2e 40 00 00       	call   80104300 <sleep>
    while (input.r == input.w)
801002d2:	a1 a0 ef 10 80       	mov    0x8010efa0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if (myproc()->killed)
801002e2:	e8 49 39 00 00       	call   80103c30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 c0 ef 10 80       	push   $0x8010efc0
801002f6:	e8 05 45 00 00       	call   80104800 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 3c 17 00 00       	call   80101a40 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 a0 ef 10 80    	mov    %edx,0x8010efa0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 20 ef 10 80 	movsbl -0x7fef10e0(%edx),%ecx
    if (c == C('D'))
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if (c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 c0 ef 10 80       	push   $0x8010efc0
8010034c:	e8 af 44 00 00       	call   80104800 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 e6 16 00 00       	call   80101a40 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if (n < target)
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 a0 ef 10 80       	mov    %eax,0x8010efa0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 f4 ef 10 80 00 	movl   $0x0,0x8010eff4
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 12 28 00 00       	call   80102bb0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 74 10 80       	push   $0x8010748d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f7 7d 10 80 	movl   $0x80107df7,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 42 00 00       	call   801046b0 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 74 10 80       	push   $0x801074a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for (i = 0; i < 10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 f8 ef 10 80 01 	movl   $0x1,0x8010eff8
801003f0:	00 00 00 
  for (;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
void consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if (c == BACKSPACE)
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 5b 00 00       	call   80105f70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if (c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if (c == BACKSPACE)
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if (pos < 0 || pos > 25 * 80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if ((pos / 80) >= 24)
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT + 1, pos >> 8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT + 1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT + 1, pos >> 8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
    if (pos > 0)
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos % 80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 66 5a 00 00       	call   80105f70 <uartputc>
    uartputc(' ');
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 5a 00 00       	call   80105f70 <uartputc>
    uartputc('\b');
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 5a 00 00       	call   80105f70 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT + 1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 6a 44 00 00       	call   801049c0 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 b5 43 00 00       	call   80104920 <memset>
  outb(CRTPORT + 1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 74 10 80       	push   $0x801074a5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 7c 15 00 00       	call   80101b20 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 c0 ef 10 80 	movl   $0x8010efc0,(%esp)
801005ab:	e8 b0 42 00 00       	call   80104860 <acquire>
  for (i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if (panicked)
801005bd:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for (;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for (i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 c0 ef 10 80       	push   $0x8010efc0
801005e4:	e8 17 42 00 00       	call   80104800 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 4e 14 00 00       	call   80101a40 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if (sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 08 75 10 80 	movzbl -0x7fef8af8(%edx),%edx
  } while ((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  } while ((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if (sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while (--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if (panicked)
80100662:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for (;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while (--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 f4 ef 10 80       	mov    0x8010eff4,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint *)(void *)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if (c != '%')
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if (c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch (c)
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if (locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if ((s = (char *)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for (; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if (panicked)
80100760:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for (;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if (panicked)
801007a8:	8b 0d f8 ef 10 80    	mov    0x8010eff8,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for (;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if (panicked)
801007b8:	a1 f8 ef 10 80       	mov    0x8010eff8,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 c0 ef 10 80       	push   $0x8010efc0
801007e8:	e8 73 40 00 00       	call   80104860 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if (panicked)
801007f5:	8b 0d f8 ef 10 80    	mov    0x8010eff8,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for (;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for (; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for (;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf b8 74 10 80       	mov    $0x801074b8,%edi
      for (; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 c0 ef 10 80       	push   $0x8010efc0
8010085b:	e8 a0 3f 00 00       	call   80104800 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if ((s = (char *)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 74 10 80       	push   $0x801074bf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	53                   	push   %ebx
80100886:	83 ec 38             	sub    $0x38,%esp
80100889:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088c:	68 c0 ef 10 80       	push   $0x8010efc0
80100891:	e8 ca 3f 00 00       	call   80104860 <acquire>
  int c, doprocdump = 0;
80100896:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while ((c = getc()) >= 0)
8010089d:	83 c4 10             	add    $0x10,%esp
801008a0:	ff d7                	call   *%edi
801008a2:	89 c3                	mov    %eax,%ebx
801008a4:	85 c0                	test   %eax,%eax
801008a6:	0f 88 4c 02 00 00    	js     80100af8 <consoleintr+0x278>
    switch (c)
801008ac:	83 fb 15             	cmp    $0x15,%ebx
801008af:	7f 5f                	jg     80100910 <consoleintr+0x90>
801008b1:	83 fb 07             	cmp    $0x7,%ebx
801008b4:	0f 8e 66 02 00 00    	jle    80100b20 <consoleintr+0x2a0>
801008ba:	8d 43 f8             	lea    -0x8(%ebx),%eax
801008bd:	83 f8 0d             	cmp    $0xd,%eax
801008c0:	0f 87 5a 02 00 00    	ja     80100b20 <consoleintr+0x2a0>
801008c6:	ff 24 85 d0 74 10 80 	jmp    *-0x7fef8b30(,%eax,4)
801008cd:	b8 00 01 00 00       	mov    $0x100,%eax
801008d2:	e8 29 fb ff ff       	call   80100400 <consputc.part.0>
      while (input.e != input.w &&
801008d7:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
801008dc:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
801008e2:	74 bc                	je     801008a0 <consoleintr+0x20>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
801008e4:	83 e8 01             	sub    $0x1,%eax
801008e7:	89 c2                	mov    %eax,%edx
801008e9:	83 e2 7f             	and    $0x7f,%edx
      while (input.e != input.w &&
801008ec:	80 ba 20 ef 10 80 0a 	cmpb   $0xa,-0x7fef10e0(%edx)
801008f3:	74 ab                	je     801008a0 <consoleintr+0x20>
  if (panicked)
801008f5:	8b 35 f8 ef 10 80    	mov    0x8010eff8,%esi
        input.size--;
801008fb:	83 2d ac ef 10 80 01 	subl   $0x1,0x8010efac
        input.e--;
80100902:	a3 a8 ef 10 80       	mov    %eax,0x8010efa8
  if (panicked)
80100907:	85 f6                	test   %esi,%esi
80100909:	74 c2                	je     801008cd <consoleintr+0x4d>
8010090b:	fa                   	cli    
    for (;;)
8010090c:	eb fe                	jmp    8010090c <consoleintr+0x8c>
8010090e:	66 90                	xchg   %ax,%ax
    switch (c)
80100910:	83 fb 7f             	cmp    $0x7f,%ebx
80100913:	0f 84 af 01 00 00    	je     80100ac8 <consoleintr+0x248>
      if (c != 0 && input.e - input.r < INPUT_BUF)
80100919:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
8010091e:	89 c2                	mov    %eax,%edx
80100920:	2b 15 a0 ef 10 80    	sub    0x8010efa0,%edx
80100926:	83 fa 7f             	cmp    $0x7f,%edx
80100929:	0f 87 71 ff ff ff    	ja     801008a0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092f:	89 da                	mov    %ebx,%edx
        c = (c == '\r') ? '\n' : c;
80100931:	83 fb 0d             	cmp    $0xd,%ebx
80100934:	75 0a                	jne    80100940 <consoleintr+0xc0>
80100936:	ba 0a 00 00 00       	mov    $0xa,%edx
8010093b:	bb 0a 00 00 00       	mov    $0xa,%ebx
  if (panicked)
80100940:	8b 35 f8 ef 10 80    	mov    0x8010eff8,%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100946:	8d 48 01             	lea    0x1(%eax),%ecx
80100949:	83 e0 7f             	and    $0x7f,%eax
8010094c:	89 0d a8 ef 10 80    	mov    %ecx,0x8010efa8
80100952:	88 90 20 ef 10 80    	mov    %dl,-0x7fef10e0(%eax)
  if (panicked)
80100958:	85 f6                	test   %esi,%esi
8010095a:	0f 85 a8 02 00 00    	jne    80100c08 <consoleintr+0x388>
80100960:	89 d8                	mov    %ebx,%eax
80100962:	e8 99 fa ff ff       	call   80100400 <consputc.part.0>
        input.size++;
80100967:	a1 ac ef 10 80       	mov    0x8010efac,%eax
        if (buf_copy_size > 0 && input.e != input.size)
8010096c:	8b 0d 84 ee 10 80    	mov    0x8010ee84,%ecx
80100972:	8b 15 a8 ef 10 80    	mov    0x8010efa8,%edx
        input.size++;
80100978:	83 c0 01             	add    $0x1,%eax
        if (buf_copy_size > 0 && input.e != input.size)
8010097b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        input.size++;
8010097e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100981:	a3 ac ef 10 80       	mov    %eax,0x8010efac
        if (buf_copy_size > 0 && input.e != input.size)
80100986:	85 c9                	test   %ecx,%ecx
80100988:	7e 08                	jle    80100992 <consoleintr+0x112>
8010098a:	39 d0                	cmp    %edx,%eax
8010098c:	0f 85 d0 02 00 00    	jne    80100c62 <consoleintr+0x3e2>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
80100992:	83 fb 0a             	cmp    $0xa,%ebx
80100995:	74 15                	je     801009ac <consoleintr+0x12c>
80100997:	83 fb 04             	cmp    $0x4,%ebx
8010099a:	74 10                	je     801009ac <consoleintr+0x12c>
8010099c:	a1 a0 ef 10 80       	mov    0x8010efa0,%eax
801009a1:	83 e8 80             	sub    $0xffffff80,%eax
801009a4:	39 d0                	cmp    %edx,%eax
801009a6:	0f 85 f4 fe ff ff    	jne    801008a0 <consoleintr+0x20>
          wakeup(&input.r);
801009ac:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009af:	89 15 a4 ef 10 80    	mov    %edx,0x8010efa4
          wakeup(&input.r);
801009b5:	68 a0 ef 10 80       	push   $0x8010efa0
801009ba:	e8 01 3a 00 00       	call   801043c0 <wakeup>
801009bf:	83 c4 10             	add    $0x10,%esp
801009c2:	e9 d9 fe ff ff       	jmp    801008a0 <consoleintr+0x20>
801009c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009ce:	66 90                	xchg   %ax,%ax
      if (input.e > input.w + 1)
801009d0:	8b 0d a4 ef 10 80    	mov    0x8010efa4,%ecx
801009d6:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
801009db:	8d 51 01             	lea    0x1(%ecx),%edx
801009de:	39 d0                	cmp    %edx,%eax
801009e0:	0f 86 ba fe ff ff    	jbe    801008a0 <consoleintr+0x20>
        int dis = (input.e % INPUT_BUF) - (input.w % INPUT_BUF);
801009e6:	83 e0 7f             	and    $0x7f,%eax
801009e9:	83 e1 7f             	and    $0x7f,%ecx
801009ec:	89 c3                	mov    %eax,%ebx
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
801009ee:	8d 50 ff             	lea    -0x1(%eax),%edx
        int start = input.w % INPUT_BUF;
801009f1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
        int dis = (input.e % INPUT_BUF) - (input.w % INPUT_BUF);
801009f4:	29 cb                	sub    %ecx,%ebx
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
801009f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801009f9:	8d 90 1f ef 10 80    	lea    -0x7fef10e1(%eax),%edx
        for (int i = 0; i <= (dis / 2) - 1; i++)
801009ff:	31 c0                	xor    %eax,%eax
80100a01:	89 de                	mov    %ebx,%esi
80100a03:	c1 ee 1f             	shr    $0x1f,%esi
80100a06:	01 de                	add    %ebx,%esi
80100a08:	d1 fe                	sar    %esi
80100a0a:	83 fb 01             	cmp    $0x1,%ebx
80100a0d:	7e 28                	jle    80100a37 <consoleintr+0x1b7>
80100a0f:	90                   	nop
          char temp = input.buf[start];
80100a10:	0f b6 9c 01 20 ef 10 	movzbl -0x7fef10e0(%ecx,%eax,1),%ebx
80100a17:	80 
        for (int i = 0; i <= (dis / 2) - 1; i++)
80100a18:	83 ea 01             	sub    $0x1,%edx
          char temp = input.buf[start];
80100a1b:	88 5d e4             	mov    %bl,-0x1c(%ebp)
          input.buf[start] = input.buf[((input.e % INPUT_BUF) - i) - 1];
80100a1e:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
80100a22:	88 9c 01 20 ef 10 80 	mov    %bl,-0x7fef10e0(%ecx,%eax,1)
          input.buf[((input.e % INPUT_BUF) - i) - 1] = temp;
80100a29:	0f b6 5d e4          	movzbl -0x1c(%ebp),%ebx
        for (int i = 0; i <= (dis / 2) - 1; i++)
80100a2d:	83 c0 01             	add    $0x1,%eax
          input.buf[((input.e % INPUT_BUF) - i) - 1] = temp;
80100a30:	88 5a 01             	mov    %bl,0x1(%edx)
        for (int i = 0; i <= (dis / 2) - 1; i++)
80100a33:	39 f0                	cmp    %esi,%eax
80100a35:	7c d9                	jl     80100a10 <consoleintr+0x190>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100a37:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80100a3a:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
80100a3d:	0f 82 5d fe ff ff    	jb     801008a0 <consoleintr+0x20>
  if (panicked)
80100a43:	8b 35 f8 ef 10 80    	mov    0x8010eff8,%esi
80100a49:	85 f6                	test   %esi,%esi
80100a4b:	0f 84 6f 01 00 00    	je     80100bc0 <consoleintr+0x340>
80100a51:	fa                   	cli    
    for (;;)
80100a52:	eb fe                	jmp    80100a52 <consoleintr+0x1d2>
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.e > input.w + 1)
80100a58:	8b 1d a4 ef 10 80    	mov    0x8010efa4,%ebx
80100a5e:	8b 35 a8 ef 10 80    	mov    0x8010efa8,%esi
80100a64:	8d 43 01             	lea    0x1(%ebx),%eax
80100a67:	39 c6                	cmp    %eax,%esi
80100a69:	0f 86 31 fe ff ff    	jbe    801008a0 <consoleintr+0x20>
        int last = (input.e % INPUT_BUF);
80100a6f:	89 f1                	mov    %esi,%ecx
        for (int i = input.w; i < last; i++)
80100a71:	89 da                	mov    %ebx,%edx
        int last = (input.e % INPUT_BUF);
80100a73:	83 e1 7f             	and    $0x7f,%ecx
        for (int i = input.w; i < last; i++)
80100a76:	39 d9                	cmp    %ebx,%ecx
80100a78:	7f 11                	jg     80100a8b <consoleintr+0x20b>
80100a7a:	e9 c9 00 00 00       	jmp    80100b48 <consoleintr+0x2c8>
80100a7f:	90                   	nop
80100a80:	83 c2 01             	add    $0x1,%edx
80100a83:	39 d1                	cmp    %edx,%ecx
80100a85:	0f 8e bd 00 00 00    	jle    80100b48 <consoleintr+0x2c8>
          if (input.buf[i] >= '0' && input.buf[i] <= '9')
80100a8b:	0f b6 82 20 ef 10 80 	movzbl -0x7fef10e0(%edx),%eax
80100a92:	83 e8 30             	sub    $0x30,%eax
80100a95:	3c 09                	cmp    $0x9,%al
80100a97:	77 e7                	ja     80100a80 <consoleintr+0x200>
            for (int j = i; j < last - 1; j++)
80100a99:	83 e9 01             	sub    $0x1,%ecx
80100a9c:	39 d1                	cmp    %edx,%ecx
80100a9e:	7e e0                	jle    80100a80 <consoleintr+0x200>
80100aa0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100aa3:	89 d0                	mov    %edx,%eax
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
              input.buf[j] = input.buf[j + 1];
80100aa8:	0f b6 90 21 ef 10 80 	movzbl -0x7fef10df(%eax),%edx
80100aaf:	83 c0 01             	add    $0x1,%eax
80100ab2:	88 90 1f ef 10 80    	mov    %dl,-0x7fef10e1(%eax)
            for (int j = i; j < last - 1; j++)
80100ab8:	39 c8                	cmp    %ecx,%eax
80100aba:	75 ec                	jne    80100aa8 <consoleintr+0x228>
80100abc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100abf:	eb bf                	jmp    80100a80 <consoleintr+0x200>
80100ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w)
80100ac8:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100acd:	3b 05 a4 ef 10 80    	cmp    0x8010efa4,%eax
80100ad3:	0f 84 c7 fd ff ff    	je     801008a0 <consoleintr+0x20>
  if (panicked)
80100ad9:	8b 1d f8 ef 10 80    	mov    0x8010eff8,%ebx
        input.e--;
80100adf:	83 e8 01             	sub    $0x1,%eax
        input.size--;
80100ae2:	83 2d ac ef 10 80 01 	subl   $0x1,0x8010efac
        input.e--;
80100ae9:	a3 a8 ef 10 80       	mov    %eax,0x8010efa8
  if (panicked)
80100aee:	85 db                	test   %ebx,%ebx
80100af0:	74 7e                	je     80100b70 <consoleintr+0x2f0>
80100af2:	fa                   	cli    
    for (;;)
80100af3:	eb fe                	jmp    80100af3 <consoleintr+0x273>
80100af5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100af8:	83 ec 0c             	sub    $0xc,%esp
80100afb:	68 c0 ef 10 80       	push   $0x8010efc0
80100b00:	e8 fb 3c 00 00       	call   80104800 <release>
  if (doprocdump)
80100b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100b08:	83 c4 10             	add    $0x10,%esp
80100b0b:	85 c0                	test   %eax,%eax
80100b0d:	75 2d                	jne    80100b3c <consoleintr+0x2bc>
}
80100b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b12:	5b                   	pop    %ebx
80100b13:	5e                   	pop    %esi
80100b14:	5f                   	pop    %edi
80100b15:	5d                   	pop    %ebp
80100b16:	c3                   	ret    
80100b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b1e:	66 90                	xchg   %ax,%ax
      if (c != 0 && input.e - input.r < INPUT_BUF)
80100b20:	85 db                	test   %ebx,%ebx
80100b22:	0f 84 78 fd ff ff    	je     801008a0 <consoleintr+0x20>
80100b28:	e9 ec fd ff ff       	jmp    80100919 <consoleintr+0x99>
80100b2d:	8d 76 00             	lea    0x0(%esi),%esi
    switch (c)
80100b30:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80100b37:	e9 64 fd ff ff       	jmp    801008a0 <consoleintr+0x20>
}
80100b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b3f:	5b                   	pop    %ebx
80100b40:	5e                   	pop    %esi
80100b41:	5f                   	pop    %edi
80100b42:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
80100b43:	e9 58 39 00 00       	jmp    801044a0 <procdump>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100b48:	83 e6 7f             	and    $0x7f,%esi
80100b4b:	83 e3 7f             	and    $0x7f,%ebx
80100b4e:	8d 46 ff             	lea    -0x1(%esi),%eax
80100b51:	39 c3                	cmp    %eax,%ebx
80100b53:	0f 87 47 fd ff ff    	ja     801008a0 <consoleintr+0x20>
  if (panicked)
80100b59:	8b 0d f8 ef 10 80    	mov    0x8010eff8,%ecx
80100b5f:	85 c9                	test   %ecx,%ecx
80100b61:	74 1c                	je     80100b7f <consoleintr+0x2ff>
80100b63:	fa                   	cli    
    for (;;)
80100b64:	eb fe                	jmp    80100b64 <consoleintr+0x2e4>
80100b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6d:	8d 76 00             	lea    0x0(%esi),%esi
80100b70:	b8 00 01 00 00       	mov    $0x100,%eax
80100b75:	e8 86 f8 ff ff       	call   80100400 <consputc.part.0>
80100b7a:	e9 21 fd ff ff       	jmp    801008a0 <consoleintr+0x20>
80100b7f:	b8 00 01 00 00       	mov    $0x100,%eax
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100b84:	83 c3 01             	add    $0x1,%ebx
80100b87:	e8 74 f8 ff ff       	call   80100400 <consputc.part.0>
80100b8c:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100b91:	83 e0 7f             	and    $0x7f,%eax
80100b94:	83 e8 01             	sub    $0x1,%eax
80100b97:	39 d8                	cmp    %ebx,%eax
80100b99:	73 be                	jae    80100b59 <consoleintr+0x2d9>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100b9b:	8b 1d a4 ef 10 80    	mov    0x8010efa4,%ebx
80100ba1:	83 e3 7f             	and    $0x7f,%ebx
80100ba4:	39 d8                	cmp    %ebx,%eax
80100ba6:	0f 82 f4 fc ff ff    	jb     801008a0 <consoleintr+0x20>
  if (panicked)
80100bac:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
          consputc(input.buf[i] % INPUT_BUF);
80100bb2:	0f be 83 20 ef 10 80 	movsbl -0x7fef10e0(%ebx),%eax
  if (panicked)
80100bb9:	85 d2                	test   %edx,%edx
80100bbb:	74 53                	je     80100c10 <consoleintr+0x390>
80100bbd:	fa                   	cli    
    for (;;)
80100bbe:	eb fe                	jmp    80100bbe <consoleintr+0x33e>
80100bc0:	b8 00 01 00 00       	mov    $0x100,%eax
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100bc5:	83 c3 01             	add    $0x1,%ebx
80100bc8:	e8 33 f8 ff ff       	call   80100400 <consputc.part.0>
80100bcd:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100bd2:	83 e0 7f             	and    $0x7f,%eax
80100bd5:	83 e8 01             	sub    $0x1,%eax
80100bd8:	39 d8                	cmp    %ebx,%eax
80100bda:	0f 83 63 fe ff ff    	jae    80100a43 <consoleintr+0x1c3>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100be0:	8b 1d a4 ef 10 80    	mov    0x8010efa4,%ebx
80100be6:	83 e3 7f             	and    $0x7f,%ebx
80100be9:	39 d8                	cmp    %ebx,%eax
80100beb:	0f 82 af fc ff ff    	jb     801008a0 <consoleintr+0x20>
  if (panicked)
80100bf1:	8b 0d f8 ef 10 80    	mov    0x8010eff8,%ecx
          consputc(input.buf[i] % INPUT_BUF);
80100bf7:	0f be 83 20 ef 10 80 	movsbl -0x7fef10e0(%ebx),%eax
  if (panicked)
80100bfe:	85 c9                	test   %ecx,%ecx
80100c00:	74 39                	je     80100c3b <consoleintr+0x3bb>
80100c02:	fa                   	cli    
    for (;;)
80100c03:	eb fe                	jmp    80100c03 <consoleintr+0x383>
80100c05:	8d 76 00             	lea    0x0(%esi),%esi
80100c08:	fa                   	cli    
80100c09:	eb fe                	jmp    80100c09 <consoleintr+0x389>
80100c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c0f:	90                   	nop
          consputc(input.buf[i] % INPUT_BUF);
80100c10:	99                   	cltd   
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100c11:	83 c3 01             	add    $0x1,%ebx
          consputc(input.buf[i] % INPUT_BUF);
80100c14:	c1 ea 19             	shr    $0x19,%edx
80100c17:	01 d0                	add    %edx,%eax
80100c19:	83 e0 7f             	and    $0x7f,%eax
80100c1c:	29 d0                	sub    %edx,%eax
80100c1e:	e8 dd f7 ff ff       	call   80100400 <consputc.part.0>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100c23:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100c28:	83 e0 7f             	and    $0x7f,%eax
80100c2b:	83 e8 01             	sub    $0x1,%eax
80100c2e:	39 d8                	cmp    %ebx,%eax
80100c30:	0f 83 76 ff ff ff    	jae    80100bac <consoleintr+0x32c>
80100c36:	e9 65 fc ff ff       	jmp    801008a0 <consoleintr+0x20>
          consputc(input.buf[i] % INPUT_BUF);
80100c3b:	99                   	cltd   
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100c3c:	83 c3 01             	add    $0x1,%ebx
          consputc(input.buf[i] % INPUT_BUF);
80100c3f:	c1 ea 19             	shr    $0x19,%edx
80100c42:	01 d0                	add    %edx,%eax
80100c44:	83 e0 7f             	and    $0x7f,%eax
80100c47:	29 d0                	sub    %edx,%eax
80100c49:	e8 b2 f7 ff ff       	call   80100400 <consputc.part.0>
        for (int i = (input.w % INPUT_BUF); i <= (input.e % INPUT_BUF) - 1; i++)
80100c4e:	a1 a8 ef 10 80       	mov    0x8010efa8,%eax
80100c53:	83 e0 7f             	and    $0x7f,%eax
80100c56:	83 e8 01             	sub    $0x1,%eax
80100c59:	39 d8                	cmp    %ebx,%eax
80100c5b:	73 94                	jae    80100bf1 <consoleintr+0x371>
80100c5d:	e9 3e fc ff ff       	jmp    801008a0 <consoleintr+0x20>
            input.buf[e + i % INPUT_BUF] = buf_copy[i + start_index % INPUT_BUF];
80100c62:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
          int e = input.e;
80100c67:	89 55 d8             	mov    %edx,-0x28(%ebp)
          for (int i = 0; i < buf_copy_size; i++)
80100c6a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
            input.buf[e + i % INPUT_BUF] = buf_copy[i + start_index % INPUT_BUF];
80100c6d:	89 c1                	mov    %eax,%ecx
80100c6f:	c1 f9 1f             	sar    $0x1f,%ecx
80100c72:	c1 e9 19             	shr    $0x19,%ecx
80100c75:	01 c8                	add    %ecx,%eax
80100c77:	83 e0 7f             	and    $0x7f,%eax
80100c7a:	29 c8                	sub    %ecx,%eax
80100c7c:	8d 8a 20 ef 10 80    	lea    -0x7fef10e0(%edx),%ecx
80100c82:	0f b6 94 30 a0 ee 10 	movzbl -0x7fef1160(%eax,%esi,1),%edx
80100c89:	80 
80100c8a:	88 14 31             	mov    %dl,(%ecx,%esi,1)
          for (int i = 0; i < buf_copy_size; i++)
80100c8d:	83 c6 01             	add    $0x1,%esi
80100c90:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100c93:	75 ed                	jne    80100c82 <consoleintr+0x402>
          for (int i = e; i < input.size; i++)
80100c95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100c98:	39 55 dc             	cmp    %edx,-0x24(%ebp)
80100c9b:	0f 86 f1 fc ff ff    	jbe    80100992 <consoleintr+0x112>
80100ca1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80100ca4:	89 d6                	mov    %edx,%esi
80100ca6:	89 df                	mov    %ebx,%edi
80100ca8:	89 d3                	mov    %edx,%ebx
            consputc(input.buf[i % INPUT_BUF]);
80100caa:	89 f1                	mov    %esi,%ecx
  if (panicked)
80100cac:	8b 15 f8 ef 10 80    	mov    0x8010eff8,%edx
            consputc(input.buf[i % INPUT_BUF]);
80100cb2:	c1 f9 1f             	sar    $0x1f,%ecx
80100cb5:	c1 e9 19             	shr    $0x19,%ecx
80100cb8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80100cbb:	83 e0 7f             	and    $0x7f,%eax
80100cbe:	29 c8                	sub    %ecx,%eax
80100cc0:	0f be 80 20 ef 10 80 	movsbl -0x7fef10e0(%eax),%eax
  if (panicked)
80100cc7:	85 d2                	test   %edx,%edx
80100cc9:	74 05                	je     80100cd0 <consoleintr+0x450>
80100ccb:	fa                   	cli    
    for (;;)
80100ccc:	eb fe                	jmp    80100ccc <consoleintr+0x44c>
80100cce:	66 90                	xchg   %ax,%ax
80100cd0:	e8 2b f7 ff ff       	call   80100400 <consputc.part.0>
          for (int i = e; i < input.size; i++)
80100cd5:	a1 ac ef 10 80       	mov    0x8010efac,%eax
80100cda:	83 c6 01             	add    $0x1,%esi
80100cdd:	39 f0                	cmp    %esi,%eax
80100cdf:	77 c9                	ja     80100caa <consoleintr+0x42a>
          for (int i = e; i < input.size; i++)
80100ce1:	89 da                	mov    %ebx,%edx
80100ce3:	89 fb                	mov    %edi,%ebx
80100ce5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100ce8:	39 c2                	cmp    %eax,%edx
80100cea:	73 1b                	jae    80100d07 <consoleintr+0x487>
80100cec:	8b 75 d8             	mov    -0x28(%ebp),%esi
            uartputc('\b');
80100cef:	83 ec 0c             	sub    $0xc,%esp
          for (int i = e; i < input.size; i++)
80100cf2:	83 c6 01             	add    $0x1,%esi
            uartputc('\b');
80100cf5:	6a 08                	push   $0x8
80100cf7:	e8 74 52 00 00       	call   80105f70 <uartputc>
          for (int i = e; i < input.size; i++)
80100cfc:	83 c4 10             	add    $0x10,%esp
80100cff:	39 35 ac ef 10 80    	cmp    %esi,0x8010efac
80100d05:	77 e8                	ja     80100cef <consoleintr+0x46f>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
80100d07:	8b 15 a8 ef 10 80    	mov    0x8010efa8,%edx
80100d0d:	e9 80 fc ff ff       	jmp    80100992 <consoleintr+0x112>
80100d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100d20 <consoleinit>:

void consoleinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100d26:	68 c8 74 10 80       	push   $0x801074c8
80100d2b:	68 c0 ef 10 80       	push   $0x8010efc0
80100d30:	e8 5b 39 00 00       	call   80104690 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100d35:	58                   	pop    %eax
80100d36:	5a                   	pop    %edx
80100d37:	6a 00                	push   $0x0
80100d39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100d3b:	c7 05 ac f9 10 80 90 	movl   $0x80100590,0x8010f9ac
80100d42:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100d45:	c7 05 a8 f9 10 80 80 	movl   $0x80100280,0x8010f9a8
80100d4c:	02 10 80 
  cons.locking = 1;
80100d4f:	c7 05 f4 ef 10 80 01 	movl   $0x1,0x8010eff4
80100d56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100d59:	e8 e2 19 00 00       	call   80102740 <ioapicenable>
}
80100d5e:	83 c4 10             	add    $0x10,%esp
80100d61:	c9                   	leave  
80100d62:	c3                   	ret    
80100d63:	66 90                	xchg   %ax,%ax
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	57                   	push   %edi
80100d74:	56                   	push   %esi
80100d75:	53                   	push   %ebx
80100d76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d7c:	e8 af 2e 00 00       	call   80103c30 <myproc>
80100d81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100d87:	e8 94 22 00 00       	call   80103020 <begin_op>

  if((ip = namei(path)) == 0){
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	ff 75 08             	push   0x8(%ebp)
80100d92:	e8 c9 15 00 00       	call   80102360 <namei>
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	85 c0                	test   %eax,%eax
80100d9c:	0f 84 02 03 00 00    	je     801010a4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100da2:	83 ec 0c             	sub    $0xc,%esp
80100da5:	89 c3                	mov    %eax,%ebx
80100da7:	50                   	push   %eax
80100da8:	e8 93 0c 00 00       	call   80101a40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100dad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100db3:	6a 34                	push   $0x34
80100db5:	6a 00                	push   $0x0
80100db7:	50                   	push   %eax
80100db8:	53                   	push   %ebx
80100db9:	e8 92 0f 00 00       	call   80101d50 <readi>
80100dbe:	83 c4 20             	add    $0x20,%esp
80100dc1:	83 f8 34             	cmp    $0x34,%eax
80100dc4:	74 22                	je     80100de8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100dc6:	83 ec 0c             	sub    $0xc,%esp
80100dc9:	53                   	push   %ebx
80100dca:	e8 01 0f 00 00       	call   80101cd0 <iunlockput>
    end_op();
80100dcf:	e8 bc 22 00 00       	call   80103090 <end_op>
80100dd4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ddf:	5b                   	pop    %ebx
80100de0:	5e                   	pop    %esi
80100de1:	5f                   	pop    %edi
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100de8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100def:	45 4c 46 
80100df2:	75 d2                	jne    80100dc6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100df4:	e8 07 63 00 00       	call   80107100 <setupkvm>
80100df9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100dff:	85 c0                	test   %eax,%eax
80100e01:	74 c3                	je     80100dc6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e0a:	00 
80100e0b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100e11:	0f 84 ac 02 00 00    	je     801010c3 <exec+0x353>
  sz = 0;
80100e17:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e1e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e21:	31 ff                	xor    %edi,%edi
80100e23:	e9 8e 00 00 00       	jmp    80100eb6 <exec+0x146>
80100e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e2f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100e30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e37:	75 6c                	jne    80100ea5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100e39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100e45:	0f 82 87 00 00 00    	jb     80100ed2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100e4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e51:	72 7f                	jb     80100ed2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e53:	83 ec 04             	sub    $0x4,%esp
80100e56:	50                   	push   %eax
80100e57:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100e5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e63:	e8 b8 60 00 00       	call   80106f20 <allocuvm>
80100e68:	83 c4 10             	add    $0x10,%esp
80100e6b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e71:	85 c0                	test   %eax,%eax
80100e73:	74 5d                	je     80100ed2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100e75:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e7b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e80:	75 50                	jne    80100ed2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e82:	83 ec 0c             	sub    $0xc,%esp
80100e85:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100e8b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100e91:	53                   	push   %ebx
80100e92:	50                   	push   %eax
80100e93:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e99:	e8 92 5f 00 00       	call   80106e30 <loaduvm>
80100e9e:	83 c4 20             	add    $0x20,%esp
80100ea1:	85 c0                	test   %eax,%eax
80100ea3:	78 2d                	js     80100ed2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ea5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100eac:	83 c7 01             	add    $0x1,%edi
80100eaf:	83 c6 20             	add    $0x20,%esi
80100eb2:	39 f8                	cmp    %edi,%eax
80100eb4:	7e 3a                	jle    80100ef0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100eb6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ebc:	6a 20                	push   $0x20
80100ebe:	56                   	push   %esi
80100ebf:	50                   	push   %eax
80100ec0:	53                   	push   %ebx
80100ec1:	e8 8a 0e 00 00       	call   80101d50 <readi>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	83 f8 20             	cmp    $0x20,%eax
80100ecc:	0f 84 5e ff ff ff    	je     80100e30 <exec+0xc0>
    freevm(pgdir);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
80100ed5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100edb:	e8 a0 61 00 00       	call   80107080 <freevm>
  if(ip){
80100ee0:	83 c4 10             	add    $0x10,%esp
80100ee3:	e9 de fe ff ff       	jmp    80100dc6 <exec+0x56>
80100ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eef:	90                   	nop
  sz = PGROUNDUP(sz);
80100ef0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ef6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100efc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f02:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100f08:	83 ec 0c             	sub    $0xc,%esp
80100f0b:	53                   	push   %ebx
80100f0c:	e8 bf 0d 00 00       	call   80101cd0 <iunlockput>
  end_op();
80100f11:	e8 7a 21 00 00       	call   80103090 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f16:	83 c4 0c             	add    $0xc,%esp
80100f19:	56                   	push   %esi
80100f1a:	57                   	push   %edi
80100f1b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f21:	57                   	push   %edi
80100f22:	e8 f9 5f 00 00       	call   80106f20 <allocuvm>
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	89 c6                	mov    %eax,%esi
80100f2c:	85 c0                	test   %eax,%eax
80100f2e:	0f 84 94 00 00 00    	je     80100fc8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f34:	83 ec 08             	sub    $0x8,%esp
80100f37:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100f3d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f3f:	50                   	push   %eax
80100f40:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100f41:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f43:	e8 58 62 00 00       	call   801071a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f48:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f4b:	83 c4 10             	add    $0x10,%esp
80100f4e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f54:	8b 00                	mov    (%eax),%eax
80100f56:	85 c0                	test   %eax,%eax
80100f58:	0f 84 8b 00 00 00    	je     80100fe9 <exec+0x279>
80100f5e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100f64:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100f6a:	eb 23                	jmp    80100f8f <exec+0x21f>
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f70:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f73:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100f7a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100f7d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100f83:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100f86:	85 c0                	test   %eax,%eax
80100f88:	74 59                	je     80100fe3 <exec+0x273>
    if(argc >= MAXARG)
80100f8a:	83 ff 20             	cmp    $0x20,%edi
80100f8d:	74 39                	je     80100fc8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f8f:	83 ec 0c             	sub    $0xc,%esp
80100f92:	50                   	push   %eax
80100f93:	e8 88 3b 00 00       	call   80104b20 <strlen>
80100f98:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9a:	58                   	pop    %eax
80100f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f9e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fa4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa7:	e8 74 3b 00 00       	call   80104b20 <strlen>
80100fac:	83 c0 01             	add    $0x1,%eax
80100faf:	50                   	push   %eax
80100fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fb3:	ff 34 b8             	push   (%eax,%edi,4)
80100fb6:	53                   	push   %ebx
80100fb7:	56                   	push   %esi
80100fb8:	e8 b3 63 00 00       	call   80107370 <copyout>
80100fbd:	83 c4 20             	add    $0x20,%esp
80100fc0:	85 c0                	test   %eax,%eax
80100fc2:	79 ac                	jns    80100f70 <exec+0x200>
80100fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100fd1:	e8 aa 60 00 00       	call   80107080 <freevm>
80100fd6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fde:	e9 f9 fd ff ff       	jmp    80100ddc <exec+0x6c>
80100fe3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fe9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ff0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100ff2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ff9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ffd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100fff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101002:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101008:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010100a:	50                   	push   %eax
8010100b:	52                   	push   %edx
8010100c:	53                   	push   %ebx
8010100d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101013:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010101a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010101d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101023:	e8 48 63 00 00       	call   80107370 <copyout>
80101028:	83 c4 10             	add    $0x10,%esp
8010102b:	85 c0                	test   %eax,%eax
8010102d:	78 99                	js     80100fc8 <exec+0x258>
  for(last=s=path; *s; s++)
8010102f:	8b 45 08             	mov    0x8(%ebp),%eax
80101032:	8b 55 08             	mov    0x8(%ebp),%edx
80101035:	0f b6 00             	movzbl (%eax),%eax
80101038:	84 c0                	test   %al,%al
8010103a:	74 13                	je     8010104f <exec+0x2df>
8010103c:	89 d1                	mov    %edx,%ecx
8010103e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101040:	83 c1 01             	add    $0x1,%ecx
80101043:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101045:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101048:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010104b:	84 c0                	test   %al,%al
8010104d:	75 f1                	jne    80101040 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010104f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101055:	83 ec 04             	sub    $0x4,%esp
80101058:	6a 10                	push   $0x10
8010105a:	89 f8                	mov    %edi,%eax
8010105c:	52                   	push   %edx
8010105d:	83 c0 6c             	add    $0x6c,%eax
80101060:	50                   	push   %eax
80101061:	e8 7a 3a 00 00       	call   80104ae0 <safestrcpy>
  curproc->pgdir = pgdir;
80101066:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010106c:	89 f8                	mov    %edi,%eax
8010106e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101071:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101073:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101076:	89 c1                	mov    %eax,%ecx
80101078:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010107e:	8b 40 18             	mov    0x18(%eax),%eax
80101081:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101084:	8b 41 18             	mov    0x18(%ecx),%eax
80101087:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010108a:	89 0c 24             	mov    %ecx,(%esp)
8010108d:	e8 0e 5c 00 00       	call   80106ca0 <switchuvm>
  freevm(oldpgdir);
80101092:	89 3c 24             	mov    %edi,(%esp)
80101095:	e8 e6 5f 00 00       	call   80107080 <freevm>
  return 0;
8010109a:	83 c4 10             	add    $0x10,%esp
8010109d:	31 c0                	xor    %eax,%eax
8010109f:	e9 38 fd ff ff       	jmp    80100ddc <exec+0x6c>
    end_op();
801010a4:	e8 e7 1f 00 00       	call   80103090 <end_op>
    cprintf("exec: fail\n");
801010a9:	83 ec 0c             	sub    $0xc,%esp
801010ac:	68 19 75 10 80       	push   $0x80107519
801010b1:	e8 ea f5 ff ff       	call   801006a0 <cprintf>
    return -1;
801010b6:	83 c4 10             	add    $0x10,%esp
801010b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010be:	e9 19 fd ff ff       	jmp    80100ddc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010c3:	be 00 20 00 00       	mov    $0x2000,%esi
801010c8:	31 ff                	xor    %edi,%edi
801010ca:	e9 39 fe ff ff       	jmp    80100f08 <exec+0x198>
801010cf:	90                   	nop

801010d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801010d6:	68 25 75 10 80       	push   $0x80107525
801010db:	68 00 f0 10 80       	push   $0x8010f000
801010e0:	e8 ab 35 00 00       	call   80104690 <initlock>
}
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	c9                   	leave  
801010e9:	c3                   	ret    
801010ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010f4:	bb 34 f0 10 80       	mov    $0x8010f034,%ebx
{
801010f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801010fc:	68 00 f0 10 80       	push   $0x8010f000
80101101:	e8 5a 37 00 00       	call   80104860 <acquire>
80101106:	83 c4 10             	add    $0x10,%esp
80101109:	eb 10                	jmp    8010111b <filealloc+0x2b>
8010110b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010110f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101110:	83 c3 18             	add    $0x18,%ebx
80101113:	81 fb 94 f9 10 80    	cmp    $0x8010f994,%ebx
80101119:	74 25                	je     80101140 <filealloc+0x50>
    if(f->ref == 0){
8010111b:	8b 43 04             	mov    0x4(%ebx),%eax
8010111e:	85 c0                	test   %eax,%eax
80101120:	75 ee                	jne    80101110 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101122:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101125:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010112c:	68 00 f0 10 80       	push   $0x8010f000
80101131:	e8 ca 36 00 00       	call   80104800 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101136:	89 d8                	mov    %ebx,%eax
      return f;
80101138:	83 c4 10             	add    $0x10,%esp
}
8010113b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010113e:	c9                   	leave  
8010113f:	c3                   	ret    
  release(&ftable.lock);
80101140:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101143:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101145:	68 00 f0 10 80       	push   $0x8010f000
8010114a:	e8 b1 36 00 00       	call   80104800 <release>
}
8010114f:	89 d8                	mov    %ebx,%eax
  return 0;
80101151:	83 c4 10             	add    $0x10,%esp
}
80101154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101157:	c9                   	leave  
80101158:	c3                   	ret    
80101159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101160 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	53                   	push   %ebx
80101164:	83 ec 10             	sub    $0x10,%esp
80101167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010116a:	68 00 f0 10 80       	push   $0x8010f000
8010116f:	e8 ec 36 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80101174:	8b 43 04             	mov    0x4(%ebx),%eax
80101177:	83 c4 10             	add    $0x10,%esp
8010117a:	85 c0                	test   %eax,%eax
8010117c:	7e 1a                	jle    80101198 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010117e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101181:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101184:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101187:	68 00 f0 10 80       	push   $0x8010f000
8010118c:	e8 6f 36 00 00       	call   80104800 <release>
  return f;
}
80101191:	89 d8                	mov    %ebx,%eax
80101193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101196:	c9                   	leave  
80101197:	c3                   	ret    
    panic("filedup");
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	68 2c 75 10 80       	push   $0x8010752c
801011a0:	e8 db f1 ff ff       	call   80100380 <panic>
801011a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 28             	sub    $0x28,%esp
801011b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011bc:	68 00 f0 10 80       	push   $0x8010f000
801011c1:	e8 9a 36 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
801011c6:	8b 53 04             	mov    0x4(%ebx),%edx
801011c9:	83 c4 10             	add    $0x10,%esp
801011cc:	85 d2                	test   %edx,%edx
801011ce:	0f 8e a5 00 00 00    	jle    80101279 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801011d4:	83 ea 01             	sub    $0x1,%edx
801011d7:	89 53 04             	mov    %edx,0x4(%ebx)
801011da:	75 44                	jne    80101220 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801011dc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801011e0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801011e3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801011e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801011eb:	8b 73 0c             	mov    0xc(%ebx),%esi
801011ee:	88 45 e7             	mov    %al,-0x19(%ebp)
801011f1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801011f4:	68 00 f0 10 80       	push   $0x8010f000
  ff = *f;
801011f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801011fc:	e8 ff 35 00 00       	call   80104800 <release>

  if(ff.type == FD_PIPE)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	83 ff 01             	cmp    $0x1,%edi
80101207:	74 57                	je     80101260 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101209:	83 ff 02             	cmp    $0x2,%edi
8010120c:	74 2a                	je     80101238 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010120e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101211:	5b                   	pop    %ebx
80101212:	5e                   	pop    %esi
80101213:	5f                   	pop    %edi
80101214:	5d                   	pop    %ebp
80101215:	c3                   	ret    
80101216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010121d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101220:	c7 45 08 00 f0 10 80 	movl   $0x8010f000,0x8(%ebp)
}
80101227:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122a:	5b                   	pop    %ebx
8010122b:	5e                   	pop    %esi
8010122c:	5f                   	pop    %edi
8010122d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010122e:	e9 cd 35 00 00       	jmp    80104800 <release>
80101233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101237:	90                   	nop
    begin_op();
80101238:	e8 e3 1d 00 00       	call   80103020 <begin_op>
    iput(ff.ip);
8010123d:	83 ec 0c             	sub    $0xc,%esp
80101240:	ff 75 e0             	push   -0x20(%ebp)
80101243:	e8 28 09 00 00       	call   80101b70 <iput>
    end_op();
80101248:	83 c4 10             	add    $0x10,%esp
}
8010124b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124e:	5b                   	pop    %ebx
8010124f:	5e                   	pop    %esi
80101250:	5f                   	pop    %edi
80101251:	5d                   	pop    %ebp
    end_op();
80101252:	e9 39 1e 00 00       	jmp    80103090 <end_op>
80101257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101260:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	53                   	push   %ebx
80101268:	56                   	push   %esi
80101269:	e8 82 25 00 00       	call   801037f0 <pipeclose>
8010126e:	83 c4 10             	add    $0x10,%esp
}
80101271:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101274:	5b                   	pop    %ebx
80101275:	5e                   	pop    %esi
80101276:	5f                   	pop    %edi
80101277:	5d                   	pop    %ebp
80101278:	c3                   	ret    
    panic("fileclose");
80101279:	83 ec 0c             	sub    $0xc,%esp
8010127c:	68 34 75 10 80       	push   $0x80107534
80101281:	e8 fa f0 ff ff       	call   80100380 <panic>
80101286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128d:	8d 76 00             	lea    0x0(%esi),%esi

80101290 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	53                   	push   %ebx
80101294:	83 ec 04             	sub    $0x4,%esp
80101297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010129a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010129d:	75 31                	jne    801012d0 <filestat+0x40>
    ilock(f->ip);
8010129f:	83 ec 0c             	sub    $0xc,%esp
801012a2:	ff 73 10             	push   0x10(%ebx)
801012a5:	e8 96 07 00 00       	call   80101a40 <ilock>
    stati(f->ip, st);
801012aa:	58                   	pop    %eax
801012ab:	5a                   	pop    %edx
801012ac:	ff 75 0c             	push   0xc(%ebp)
801012af:	ff 73 10             	push   0x10(%ebx)
801012b2:	e8 69 0a 00 00       	call   80101d20 <stati>
    iunlock(f->ip);
801012b7:	59                   	pop    %ecx
801012b8:	ff 73 10             	push   0x10(%ebx)
801012bb:	e8 60 08 00 00       	call   80101b20 <iunlock>
    return 0;
  }
  return -1;
}
801012c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	31 c0                	xor    %eax,%eax
}
801012c8:	c9                   	leave  
801012c9:	c3                   	ret    
801012ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801012d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012d8:	c9                   	leave  
801012d9:	c3                   	ret    
801012da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	83 ec 0c             	sub    $0xc,%esp
801012e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801012ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801012f2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801012f6:	74 60                	je     80101358 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801012f8:	8b 03                	mov    (%ebx),%eax
801012fa:	83 f8 01             	cmp    $0x1,%eax
801012fd:	74 41                	je     80101340 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012ff:	83 f8 02             	cmp    $0x2,%eax
80101302:	75 5b                	jne    8010135f <fileread+0x7f>
    ilock(f->ip);
80101304:	83 ec 0c             	sub    $0xc,%esp
80101307:	ff 73 10             	push   0x10(%ebx)
8010130a:	e8 31 07 00 00       	call   80101a40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010130f:	57                   	push   %edi
80101310:	ff 73 14             	push   0x14(%ebx)
80101313:	56                   	push   %esi
80101314:	ff 73 10             	push   0x10(%ebx)
80101317:	e8 34 0a 00 00       	call   80101d50 <readi>
8010131c:	83 c4 20             	add    $0x20,%esp
8010131f:	89 c6                	mov    %eax,%esi
80101321:	85 c0                	test   %eax,%eax
80101323:	7e 03                	jle    80101328 <fileread+0x48>
      f->off += r;
80101325:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101328:	83 ec 0c             	sub    $0xc,%esp
8010132b:	ff 73 10             	push   0x10(%ebx)
8010132e:	e8 ed 07 00 00       	call   80101b20 <iunlock>
    return r;
80101333:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101336:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101339:	89 f0                	mov    %esi,%eax
8010133b:	5b                   	pop    %ebx
8010133c:	5e                   	pop    %esi
8010133d:	5f                   	pop    %edi
8010133e:	5d                   	pop    %ebp
8010133f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101340:	8b 43 0c             	mov    0xc(%ebx),%eax
80101343:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101346:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101349:	5b                   	pop    %ebx
8010134a:	5e                   	pop    %esi
8010134b:	5f                   	pop    %edi
8010134c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010134d:	e9 3e 26 00 00       	jmp    80103990 <piperead>
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101358:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010135d:	eb d7                	jmp    80101336 <fileread+0x56>
  panic("fileread");
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	68 3e 75 10 80       	push   $0x8010753e
80101367:	e8 14 f0 ff ff       	call   80100380 <panic>
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101370 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	83 ec 1c             	sub    $0x1c,%esp
80101379:	8b 45 0c             	mov    0xc(%ebp),%eax
8010137c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010137f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101382:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101385:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010138c:	0f 84 bd 00 00 00    	je     8010144f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101392:	8b 03                	mov    (%ebx),%eax
80101394:	83 f8 01             	cmp    $0x1,%eax
80101397:	0f 84 bf 00 00 00    	je     8010145c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010139d:	83 f8 02             	cmp    $0x2,%eax
801013a0:	0f 85 c8 00 00 00    	jne    8010146e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013a9:	31 f6                	xor    %esi,%esi
    while(i < n){
801013ab:	85 c0                	test   %eax,%eax
801013ad:	7f 30                	jg     801013df <filewrite+0x6f>
801013af:	e9 94 00 00 00       	jmp    80101448 <filewrite+0xd8>
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013b8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801013bb:	83 ec 0c             	sub    $0xc,%esp
801013be:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801013c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013c4:	e8 57 07 00 00       	call   80101b20 <iunlock>
      end_op();
801013c9:	e8 c2 1c 00 00       	call   80103090 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801013ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013d1:	83 c4 10             	add    $0x10,%esp
801013d4:	39 c7                	cmp    %eax,%edi
801013d6:	75 5c                	jne    80101434 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801013d8:	01 fe                	add    %edi,%esi
    while(i < n){
801013da:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801013dd:	7e 69                	jle    80101448 <filewrite+0xd8>
      int n1 = n - i;
801013df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801013e2:	b8 00 06 00 00       	mov    $0x600,%eax
801013e7:	29 f7                	sub    %esi,%edi
801013e9:	39 c7                	cmp    %eax,%edi
801013eb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801013ee:	e8 2d 1c 00 00       	call   80103020 <begin_op>
      ilock(f->ip);
801013f3:	83 ec 0c             	sub    $0xc,%esp
801013f6:	ff 73 10             	push   0x10(%ebx)
801013f9:	e8 42 06 00 00       	call   80101a40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101401:	57                   	push   %edi
80101402:	ff 73 14             	push   0x14(%ebx)
80101405:	01 f0                	add    %esi,%eax
80101407:	50                   	push   %eax
80101408:	ff 73 10             	push   0x10(%ebx)
8010140b:	e8 40 0a 00 00       	call   80101e50 <writei>
80101410:	83 c4 20             	add    $0x20,%esp
80101413:	85 c0                	test   %eax,%eax
80101415:	7f a1                	jg     801013b8 <filewrite+0x48>
      iunlock(f->ip);
80101417:	83 ec 0c             	sub    $0xc,%esp
8010141a:	ff 73 10             	push   0x10(%ebx)
8010141d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101420:	e8 fb 06 00 00       	call   80101b20 <iunlock>
      end_op();
80101425:	e8 66 1c 00 00       	call   80103090 <end_op>
      if(r < 0)
8010142a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010142d:	83 c4 10             	add    $0x10,%esp
80101430:	85 c0                	test   %eax,%eax
80101432:	75 1b                	jne    8010144f <filewrite+0xdf>
        panic("short filewrite");
80101434:	83 ec 0c             	sub    $0xc,%esp
80101437:	68 47 75 10 80       	push   $0x80107547
8010143c:	e8 3f ef ff ff       	call   80100380 <panic>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101448:	89 f0                	mov    %esi,%eax
8010144a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010144d:	74 05                	je     80101454 <filewrite+0xe4>
8010144f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101454:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101457:	5b                   	pop    %ebx
80101458:	5e                   	pop    %esi
80101459:	5f                   	pop    %edi
8010145a:	5d                   	pop    %ebp
8010145b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010145c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010145f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101462:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101465:	5b                   	pop    %ebx
80101466:	5e                   	pop    %esi
80101467:	5f                   	pop    %edi
80101468:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101469:	e9 22 24 00 00       	jmp    80103890 <pipewrite>
  panic("filewrite");
8010146e:	83 ec 0c             	sub    $0xc,%esp
80101471:	68 4d 75 10 80       	push   $0x8010754d
80101476:	e8 05 ef ff ff       	call   80100380 <panic>
8010147b:	66 90                	xchg   %ax,%ax
8010147d:	66 90                	xchg   %ax,%ax
8010147f:	90                   	nop

80101480 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101480:	55                   	push   %ebp
80101481:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101483:	89 d0                	mov    %edx,%eax
80101485:	c1 e8 0c             	shr    $0xc,%eax
80101488:	03 05 6c 16 11 80    	add    0x8011166c,%eax
{
8010148e:	89 e5                	mov    %esp,%ebp
80101490:	56                   	push   %esi
80101491:	53                   	push   %ebx
80101492:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101494:	83 ec 08             	sub    $0x8,%esp
80101497:	50                   	push   %eax
80101498:	51                   	push   %ecx
80101499:	e8 32 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010149e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014a0:	c1 fb 03             	sar    $0x3,%ebx
801014a3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014a6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014a8:	83 e1 07             	and    $0x7,%ecx
801014ab:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014b0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014b6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014b8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014bd:	85 c1                	test   %eax,%ecx
801014bf:	74 23                	je     801014e4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014c1:	f7 d0                	not    %eax
  log_write(bp);
801014c3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014c6:	21 c8                	and    %ecx,%eax
801014c8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014cc:	56                   	push   %esi
801014cd:	e8 2e 1d 00 00       	call   80103200 <log_write>
  brelse(bp);
801014d2:	89 34 24             	mov    %esi,(%esp)
801014d5:	e8 16 ed ff ff       	call   801001f0 <brelse>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5d                   	pop    %ebp
801014e3:	c3                   	ret    
    panic("freeing free block");
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	68 57 75 10 80       	push   $0x80107557
801014ec:	e8 8f ee ff ff       	call   80100380 <panic>
801014f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ff:	90                   	nop

80101500 <balloc>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101509:	8b 0d 54 16 11 80    	mov    0x80111654,%ecx
{
8010150f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101512:	85 c9                	test   %ecx,%ecx
80101514:	0f 84 87 00 00 00    	je     801015a1 <balloc+0xa1>
8010151a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101521:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101524:	83 ec 08             	sub    $0x8,%esp
80101527:	89 f0                	mov    %esi,%eax
80101529:	c1 f8 0c             	sar    $0xc,%eax
8010152c:	03 05 6c 16 11 80    	add    0x8011166c,%eax
80101532:	50                   	push   %eax
80101533:	ff 75 d8             	push   -0x28(%ebp)
80101536:	e8 95 eb ff ff       	call   801000d0 <bread>
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101541:	a1 54 16 11 80       	mov    0x80111654,%eax
80101546:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101549:	31 c0                	xor    %eax,%eax
8010154b:	eb 2f                	jmp    8010157c <balloc+0x7c>
8010154d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101550:	89 c1                	mov    %eax,%ecx
80101552:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010155a:	83 e1 07             	and    $0x7,%ecx
8010155d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010155f:	89 c1                	mov    %eax,%ecx
80101561:	c1 f9 03             	sar    $0x3,%ecx
80101564:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101569:	89 fa                	mov    %edi,%edx
8010156b:	85 df                	test   %ebx,%edi
8010156d:	74 41                	je     801015b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010156f:	83 c0 01             	add    $0x1,%eax
80101572:	83 c6 01             	add    $0x1,%esi
80101575:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010157a:	74 05                	je     80101581 <balloc+0x81>
8010157c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010157f:	77 cf                	ja     80101550 <balloc+0x50>
    brelse(bp);
80101581:	83 ec 0c             	sub    $0xc,%esp
80101584:	ff 75 e4             	push   -0x1c(%ebp)
80101587:	e8 64 ec ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010158c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101593:	83 c4 10             	add    $0x10,%esp
80101596:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101599:	39 05 54 16 11 80    	cmp    %eax,0x80111654
8010159f:	77 80                	ja     80101521 <balloc+0x21>
  panic("balloc: out of blocks");
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	68 6a 75 10 80       	push   $0x8010756a
801015a9:	e8 d2 ed ff ff       	call   80100380 <panic>
801015ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015b6:	09 da                	or     %ebx,%edx
801015b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015bc:	57                   	push   %edi
801015bd:	e8 3e 1c 00 00       	call   80103200 <log_write>
        brelse(bp);
801015c2:	89 3c 24             	mov    %edi,(%esp)
801015c5:	e8 26 ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801015ca:	58                   	pop    %eax
801015cb:	5a                   	pop    %edx
801015cc:	56                   	push   %esi
801015cd:	ff 75 d8             	push   -0x28(%ebp)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801015d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801015d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801015da:	8d 40 5c             	lea    0x5c(%eax),%eax
801015dd:	68 00 02 00 00       	push   $0x200
801015e2:	6a 00                	push   $0x0
801015e4:	50                   	push   %eax
801015e5:	e8 36 33 00 00       	call   80104920 <memset>
  log_write(bp);
801015ea:	89 1c 24             	mov    %ebx,(%esp)
801015ed:	e8 0e 1c 00 00       	call   80103200 <log_write>
  brelse(bp);
801015f2:	89 1c 24             	mov    %ebx,(%esp)
801015f5:	e8 f6 eb ff ff       	call   801001f0 <brelse>
}
801015fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fd:	89 f0                	mov    %esi,%eax
801015ff:	5b                   	pop    %ebx
80101600:	5e                   	pop    %esi
80101601:	5f                   	pop    %edi
80101602:	5d                   	pop    %ebp
80101603:	c3                   	ret    
80101604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010160f:	90                   	nop

80101610 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	89 c7                	mov    %eax,%edi
80101616:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101617:	31 f6                	xor    %esi,%esi
{
80101619:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010161a:	bb 34 fa 10 80       	mov    $0x8010fa34,%ebx
{
8010161f:	83 ec 28             	sub    $0x28,%esp
80101622:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101625:	68 00 fa 10 80       	push   $0x8010fa00
8010162a:	e8 31 32 00 00       	call   80104860 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010162f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101632:	83 c4 10             	add    $0x10,%esp
80101635:	eb 1b                	jmp    80101652 <iget+0x42>
80101637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101640:	39 3b                	cmp    %edi,(%ebx)
80101642:	74 6c                	je     801016b0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101644:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010164a:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
80101650:	73 26                	jae    80101678 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101652:	8b 43 08             	mov    0x8(%ebx),%eax
80101655:	85 c0                	test   %eax,%eax
80101657:	7f e7                	jg     80101640 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101659:	85 f6                	test   %esi,%esi
8010165b:	75 e7                	jne    80101644 <iget+0x34>
8010165d:	85 c0                	test   %eax,%eax
8010165f:	75 76                	jne    801016d7 <iget+0xc7>
80101661:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101663:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101669:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
8010166f:	72 e1                	jb     80101652 <iget+0x42>
80101671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101678:	85 f6                	test   %esi,%esi
8010167a:	74 79                	je     801016f5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010167c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010167f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101681:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101684:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010168b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101692:	68 00 fa 10 80       	push   $0x8010fa00
80101697:	e8 64 31 00 00       	call   80104800 <release>

  return ip;
8010169c:	83 c4 10             	add    $0x10,%esp
}
8010169f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a2:	89 f0                	mov    %esi,%eax
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5f                   	pop    %edi
801016a7:	5d                   	pop    %ebp
801016a8:	c3                   	ret    
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801016b3:	75 8f                	jne    80101644 <iget+0x34>
      release(&icache.lock);
801016b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016b8:	83 c0 01             	add    $0x1,%eax
      return ip;
801016bb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016bd:	68 00 fa 10 80       	push   $0x8010fa00
      ip->ref++;
801016c2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801016c5:	e8 36 31 00 00       	call   80104800 <release>
      return ip;
801016ca:	83 c4 10             	add    $0x10,%esp
}
801016cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d0:	89 f0                	mov    %esi,%eax
801016d2:	5b                   	pop    %ebx
801016d3:	5e                   	pop    %esi
801016d4:	5f                   	pop    %edi
801016d5:	5d                   	pop    %ebp
801016d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016d7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016dd:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
801016e3:	73 10                	jae    801016f5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016e5:	8b 43 08             	mov    0x8(%ebx),%eax
801016e8:	85 c0                	test   %eax,%eax
801016ea:	0f 8f 50 ff ff ff    	jg     80101640 <iget+0x30>
801016f0:	e9 68 ff ff ff       	jmp    8010165d <iget+0x4d>
    panic("iget: no inodes");
801016f5:	83 ec 0c             	sub    $0xc,%esp
801016f8:	68 80 75 10 80       	push   $0x80107580
801016fd:	e8 7e ec ff ff       	call   80100380 <panic>
80101702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101710 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	89 c6                	mov    %eax,%esi
80101717:	53                   	push   %ebx
80101718:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010171b:	83 fa 0b             	cmp    $0xb,%edx
8010171e:	0f 86 8c 00 00 00    	jbe    801017b0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101724:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101727:	83 fb 7f             	cmp    $0x7f,%ebx
8010172a:	0f 87 a2 00 00 00    	ja     801017d2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101730:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101736:	85 c0                	test   %eax,%eax
80101738:	74 5e                	je     80101798 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010173a:	83 ec 08             	sub    $0x8,%esp
8010173d:	50                   	push   %eax
8010173e:	ff 36                	push   (%esi)
80101740:	e8 8b e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010174c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010174e:	8b 3b                	mov    (%ebx),%edi
80101750:	85 ff                	test   %edi,%edi
80101752:	74 1c                	je     80101770 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101754:	83 ec 0c             	sub    $0xc,%esp
80101757:	52                   	push   %edx
80101758:	e8 93 ea ff ff       	call   801001f0 <brelse>
8010175d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101760:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101763:	89 f8                	mov    %edi,%eax
80101765:	5b                   	pop    %ebx
80101766:	5e                   	pop    %esi
80101767:	5f                   	pop    %edi
80101768:	5d                   	pop    %ebp
80101769:	c3                   	ret    
8010176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101773:	8b 06                	mov    (%esi),%eax
80101775:	e8 86 fd ff ff       	call   80101500 <balloc>
      log_write(bp);
8010177a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010177d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101780:	89 03                	mov    %eax,(%ebx)
80101782:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101784:	52                   	push   %edx
80101785:	e8 76 1a 00 00       	call   80103200 <log_write>
8010178a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010178d:	83 c4 10             	add    $0x10,%esp
80101790:	eb c2                	jmp    80101754 <bmap+0x44>
80101792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101798:	8b 06                	mov    (%esi),%eax
8010179a:	e8 61 fd ff ff       	call   80101500 <balloc>
8010179f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017a5:	eb 93                	jmp    8010173a <bmap+0x2a>
801017a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ae:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801017b0:	8d 5a 14             	lea    0x14(%edx),%ebx
801017b3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801017b7:	85 ff                	test   %edi,%edi
801017b9:	75 a5                	jne    80101760 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801017bb:	8b 00                	mov    (%eax),%eax
801017bd:	e8 3e fd ff ff       	call   80101500 <balloc>
801017c2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801017c6:	89 c7                	mov    %eax,%edi
}
801017c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017cb:	5b                   	pop    %ebx
801017cc:	89 f8                	mov    %edi,%eax
801017ce:	5e                   	pop    %esi
801017cf:	5f                   	pop    %edi
801017d0:	5d                   	pop    %ebp
801017d1:	c3                   	ret    
  panic("bmap: out of range");
801017d2:	83 ec 0c             	sub    $0xc,%esp
801017d5:	68 90 75 10 80       	push   $0x80107590
801017da:	e8 a1 eb ff ff       	call   80100380 <panic>
801017df:	90                   	nop

801017e0 <readsb>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	6a 01                	push   $0x1
801017ed:	ff 75 08             	push   0x8(%ebp)
801017f0:	e8 db e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801017f5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801017f8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017fa:	8d 40 5c             	lea    0x5c(%eax),%eax
801017fd:	6a 1c                	push   $0x1c
801017ff:	50                   	push   %eax
80101800:	56                   	push   %esi
80101801:	e8 ba 31 00 00       	call   801049c0 <memmove>
  brelse(bp);
80101806:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101809:	83 c4 10             	add    $0x10,%esp
}
8010180c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5d                   	pop    %ebp
  brelse(bp);
80101812:	e9 d9 e9 ff ff       	jmp    801001f0 <brelse>
80101817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181e:	66 90                	xchg   %ax,%ax

80101820 <iinit>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	bb 40 fa 10 80       	mov    $0x8010fa40,%ebx
80101829:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010182c:	68 a3 75 10 80       	push   $0x801075a3
80101831:	68 00 fa 10 80       	push   $0x8010fa00
80101836:	e8 55 2e 00 00       	call   80104690 <initlock>
  for(i = 0; i < NINODE; i++) {
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101840:	83 ec 08             	sub    $0x8,%esp
80101843:	68 aa 75 10 80       	push   $0x801075aa
80101848:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101849:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010184f:	e8 0c 2d 00 00       	call   80104560 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	81 fb 60 16 11 80    	cmp    $0x80111660,%ebx
8010185d:	75 e1                	jne    80101840 <iinit+0x20>
  bp = bread(dev, 1);
8010185f:	83 ec 08             	sub    $0x8,%esp
80101862:	6a 01                	push   $0x1
80101864:	ff 75 08             	push   0x8(%ebp)
80101867:	e8 64 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010186c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010186f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101871:	8d 40 5c             	lea    0x5c(%eax),%eax
80101874:	6a 1c                	push   $0x1c
80101876:	50                   	push   %eax
80101877:	68 54 16 11 80       	push   $0x80111654
8010187c:	e8 3f 31 00 00       	call   801049c0 <memmove>
  brelse(bp);
80101881:	89 1c 24             	mov    %ebx,(%esp)
80101884:	e8 67 e9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101889:	ff 35 6c 16 11 80    	push   0x8011166c
8010188f:	ff 35 68 16 11 80    	push   0x80111668
80101895:	ff 35 64 16 11 80    	push   0x80111664
8010189b:	ff 35 60 16 11 80    	push   0x80111660
801018a1:	ff 35 5c 16 11 80    	push   0x8011165c
801018a7:	ff 35 58 16 11 80    	push   0x80111658
801018ad:	ff 35 54 16 11 80    	push   0x80111654
801018b3:	68 10 76 10 80       	push   $0x80107610
801018b8:	e8 e3 ed ff ff       	call   801006a0 <cprintf>
}
801018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018c0:	83 c4 30             	add    $0x30,%esp
801018c3:	c9                   	leave  
801018c4:	c3                   	ret    
801018c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <ialloc>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 1c             	sub    $0x1c,%esp
801018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801018dc:	83 3d 5c 16 11 80 01 	cmpl   $0x1,0x8011165c
{
801018e3:	8b 75 08             	mov    0x8(%ebp),%esi
801018e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801018e9:	0f 86 91 00 00 00    	jbe    80101980 <ialloc+0xb0>
801018ef:	bf 01 00 00 00       	mov    $0x1,%edi
801018f4:	eb 21                	jmp    80101917 <ialloc+0x47>
801018f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018fd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101900:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101903:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101906:	53                   	push   %ebx
80101907:	e8 e4 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	3b 3d 5c 16 11 80    	cmp    0x8011165c,%edi
80101915:	73 69                	jae    80101980 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101917:	89 f8                	mov    %edi,%eax
80101919:	83 ec 08             	sub    $0x8,%esp
8010191c:	c1 e8 03             	shr    $0x3,%eax
8010191f:	03 05 68 16 11 80    	add    0x80111668,%eax
80101925:	50                   	push   %eax
80101926:	56                   	push   %esi
80101927:	e8 a4 e7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010192c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010192f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101931:	89 f8                	mov    %edi,%eax
80101933:	83 e0 07             	and    $0x7,%eax
80101936:	c1 e0 06             	shl    $0x6,%eax
80101939:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010193d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101941:	75 bd                	jne    80101900 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101943:	83 ec 04             	sub    $0x4,%esp
80101946:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101949:	6a 40                	push   $0x40
8010194b:	6a 00                	push   $0x0
8010194d:	51                   	push   %ecx
8010194e:	e8 cd 2f 00 00       	call   80104920 <memset>
      dip->type = type;
80101953:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101957:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010195a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010195d:	89 1c 24             	mov    %ebx,(%esp)
80101960:	e8 9b 18 00 00       	call   80103200 <log_write>
      brelse(bp);
80101965:	89 1c 24             	mov    %ebx,(%esp)
80101968:	e8 83 e8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010196d:	83 c4 10             	add    $0x10,%esp
}
80101970:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101973:	89 fa                	mov    %edi,%edx
}
80101975:	5b                   	pop    %ebx
      return iget(dev, inum);
80101976:	89 f0                	mov    %esi,%eax
}
80101978:	5e                   	pop    %esi
80101979:	5f                   	pop    %edi
8010197a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010197b:	e9 90 fc ff ff       	jmp    80101610 <iget>
  panic("ialloc: no inodes");
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 b0 75 10 80       	push   $0x801075b0
80101988:	e8 f3 e9 ff ff       	call   80100380 <panic>
8010198d:	8d 76 00             	lea    0x0(%esi),%esi

80101990 <iupdate>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101998:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010199e:	83 ec 08             	sub    $0x8,%esp
801019a1:	c1 e8 03             	shr    $0x3,%eax
801019a4:	03 05 68 16 11 80    	add    0x80111668,%eax
801019aa:	50                   	push   %eax
801019ab:	ff 73 a4             	push   -0x5c(%ebx)
801019ae:	e8 1d e7 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801019b3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019b7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019ba:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019bc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801019d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ed:	6a 34                	push   $0x34
801019ef:	53                   	push   %ebx
801019f0:	50                   	push   %eax
801019f1:	e8 ca 2f 00 00       	call   801049c0 <memmove>
  log_write(bp);
801019f6:	89 34 24             	mov    %esi,(%esp)
801019f9:	e8 02 18 00 00       	call   80103200 <log_write>
  brelse(bp);
801019fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101a01:	83 c4 10             	add    $0x10,%esp
}
80101a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a07:	5b                   	pop    %ebx
80101a08:	5e                   	pop    %esi
80101a09:	5d                   	pop    %ebp
  brelse(bp);
80101a0a:	e9 e1 e7 ff ff       	jmp    801001f0 <brelse>
80101a0f:	90                   	nop

80101a10 <idup>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	53                   	push   %ebx
80101a14:	83 ec 10             	sub    $0x10,%esp
80101a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a1a:	68 00 fa 10 80       	push   $0x8010fa00
80101a1f:	e8 3c 2e 00 00       	call   80104860 <acquire>
  ip->ref++;
80101a24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a28:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101a2f:	e8 cc 2d 00 00       	call   80104800 <release>
}
80101a34:	89 d8                	mov    %ebx,%eax
80101a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a39:	c9                   	leave  
80101a3a:	c3                   	ret    
80101a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop

80101a40 <ilock>:
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	56                   	push   %esi
80101a44:	53                   	push   %ebx
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a48:	85 db                	test   %ebx,%ebx
80101a4a:	0f 84 b7 00 00 00    	je     80101b07 <ilock+0xc7>
80101a50:	8b 53 08             	mov    0x8(%ebx),%edx
80101a53:	85 d2                	test   %edx,%edx
80101a55:	0f 8e ac 00 00 00    	jle    80101b07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a5b:	83 ec 0c             	sub    $0xc,%esp
80101a5e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a61:	50                   	push   %eax
80101a62:	e8 39 2b 00 00       	call   801045a0 <acquiresleep>
  if(ip->valid == 0){
80101a67:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a6a:	83 c4 10             	add    $0x10,%esp
80101a6d:	85 c0                	test   %eax,%eax
80101a6f:	74 0f                	je     80101a80 <ilock+0x40>
}
80101a71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a74:	5b                   	pop    %ebx
80101a75:	5e                   	pop    %esi
80101a76:	5d                   	pop    %ebp
80101a77:	c3                   	ret    
80101a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a80:	8b 43 04             	mov    0x4(%ebx),%eax
80101a83:	83 ec 08             	sub    $0x8,%esp
80101a86:	c1 e8 03             	shr    $0x3,%eax
80101a89:	03 05 68 16 11 80    	add    0x80111668,%eax
80101a8f:	50                   	push   %eax
80101a90:	ff 33                	push   (%ebx)
80101a92:	e8 39 e6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a97:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a9a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a9c:	8b 43 04             	mov    0x4(%ebx),%eax
80101a9f:	83 e0 07             	and    $0x7,%eax
80101aa2:	c1 e0 06             	shl    $0x6,%eax
80101aa5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101aa9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101aaf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ab3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ab7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101abb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101abf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ac3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ac7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101acb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101ace:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad1:	6a 34                	push   $0x34
80101ad3:	50                   	push   %eax
80101ad4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ad7:	50                   	push   %eax
80101ad8:	e8 e3 2e 00 00       	call   801049c0 <memmove>
    brelse(bp);
80101add:	89 34 24             	mov    %esi,(%esp)
80101ae0:	e8 0b e7 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101ae5:	83 c4 10             	add    $0x10,%esp
80101ae8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101aed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101af4:	0f 85 77 ff ff ff    	jne    80101a71 <ilock+0x31>
      panic("ilock: no type");
80101afa:	83 ec 0c             	sub    $0xc,%esp
80101afd:	68 c8 75 10 80       	push   $0x801075c8
80101b02:	e8 79 e8 ff ff       	call   80100380 <panic>
    panic("ilock");
80101b07:	83 ec 0c             	sub    $0xc,%esp
80101b0a:	68 c2 75 10 80       	push   $0x801075c2
80101b0f:	e8 6c e8 ff ff       	call   80100380 <panic>
80101b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b1f:	90                   	nop

80101b20 <iunlock>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 28                	je     80101b54 <iunlock+0x34>
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b32:	56                   	push   %esi
80101b33:	e8 08 2b 00 00       	call   80104640 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 15                	je     80101b54 <iunlock+0x34>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 0e                	jle    80101b54 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b4c:	5b                   	pop    %ebx
80101b4d:	5e                   	pop    %esi
80101b4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b4f:	e9 ac 2a 00 00       	jmp    80104600 <releasesleep>
    panic("iunlock");
80101b54:	83 ec 0c             	sub    $0xc,%esp
80101b57:	68 d7 75 10 80       	push   $0x801075d7
80101b5c:	e8 1f e8 ff ff       	call   80100380 <panic>
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <iput>:
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 28             	sub    $0x28,%esp
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b7f:	57                   	push   %edi
80101b80:	e8 1b 2a 00 00       	call   801045a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b88:	83 c4 10             	add    $0x10,%esp
80101b8b:	85 d2                	test   %edx,%edx
80101b8d:	74 07                	je     80101b96 <iput+0x26>
80101b8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b94:	74 32                	je     80101bc8 <iput+0x58>
  releasesleep(&ip->lock);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	57                   	push   %edi
80101b9a:	e8 61 2a 00 00       	call   80104600 <releasesleep>
  acquire(&icache.lock);
80101b9f:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101ba6:	e8 b5 2c 00 00       	call   80104860 <acquire>
  ip->ref--;
80101bab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101baf:	83 c4 10             	add    $0x10,%esp
80101bb2:	c7 45 08 00 fa 10 80 	movl   $0x8010fa00,0x8(%ebp)
}
80101bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbc:	5b                   	pop    %ebx
80101bbd:	5e                   	pop    %esi
80101bbe:	5f                   	pop    %edi
80101bbf:	5d                   	pop    %ebp
  release(&icache.lock);
80101bc0:	e9 3b 2c 00 00       	jmp    80104800 <release>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 00 fa 10 80       	push   $0x8010fa00
80101bd0:	e8 8b 2c 00 00       	call   80104860 <acquire>
    int r = ip->ref;
80101bd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bd8:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101bdf:	e8 1c 2c 00 00       	call   80104800 <release>
    if(r == 1){
80101be4:	83 c4 10             	add    $0x10,%esp
80101be7:	83 fe 01             	cmp    $0x1,%esi
80101bea:	75 aa                	jne    80101b96 <iput+0x26>
80101bec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101bf2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bf5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101bf8:	89 cf                	mov    %ecx,%edi
80101bfa:	eb 0b                	jmp    80101c07 <iput+0x97>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c00:	83 c6 04             	add    $0x4,%esi
80101c03:	39 fe                	cmp    %edi,%esi
80101c05:	74 19                	je     80101c20 <iput+0xb0>
    if(ip->addrs[i]){
80101c07:	8b 16                	mov    (%esi),%edx
80101c09:	85 d2                	test   %edx,%edx
80101c0b:	74 f3                	je     80101c00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c0d:	8b 03                	mov    (%ebx),%eax
80101c0f:	e8 6c f8 ff ff       	call   80101480 <bfree>
      ip->addrs[i] = 0;
80101c14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c1a:	eb e4                	jmp    80101c00 <iput+0x90>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c29:	85 c0                	test   %eax,%eax
80101c2b:	75 2d                	jne    80101c5a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c37:	53                   	push   %ebx
80101c38:	e8 53 fd ff ff       	call   80101990 <iupdate>
      ip->type = 0;
80101c3d:	31 c0                	xor    %eax,%eax
80101c3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c43:	89 1c 24             	mov    %ebx,(%esp)
80101c46:	e8 45 fd ff ff       	call   80101990 <iupdate>
      ip->valid = 0;
80101c4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c52:	83 c4 10             	add    $0x10,%esp
80101c55:	e9 3c ff ff ff       	jmp    80101b96 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c5a:	83 ec 08             	sub    $0x8,%esp
80101c5d:	50                   	push   %eax
80101c5e:	ff 33                	push   (%ebx)
80101c60:	e8 6b e4 ff ff       	call   801000d0 <bread>
80101c65:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c68:	83 c4 10             	add    $0x10,%esp
80101c6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c74:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c77:	89 cf                	mov    %ecx,%edi
80101c79:	eb 0c                	jmp    80101c87 <iput+0x117>
80101c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c7f:	90                   	nop
80101c80:	83 c6 04             	add    $0x4,%esi
80101c83:	39 f7                	cmp    %esi,%edi
80101c85:	74 0f                	je     80101c96 <iput+0x126>
      if(a[j])
80101c87:	8b 16                	mov    (%esi),%edx
80101c89:	85 d2                	test   %edx,%edx
80101c8b:	74 f3                	je     80101c80 <iput+0x110>
        bfree(ip->dev, a[j]);
80101c8d:	8b 03                	mov    (%ebx),%eax
80101c8f:	e8 ec f7 ff ff       	call   80101480 <bfree>
80101c94:	eb ea                	jmp    80101c80 <iput+0x110>
    brelse(bp);
80101c96:	83 ec 0c             	sub    $0xc,%esp
80101c99:	ff 75 e4             	push   -0x1c(%ebp)
80101c9c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c9f:	e8 4c e5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ca4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101caa:	8b 03                	mov    (%ebx),%eax
80101cac:	e8 cf f7 ff ff       	call   80101480 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cb1:	83 c4 10             	add    $0x10,%esp
80101cb4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101cbb:	00 00 00 
80101cbe:	e9 6a ff ff ff       	jmp    80101c2d <iput+0xbd>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <iunlockput>:
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	56                   	push   %esi
80101cd4:	53                   	push   %ebx
80101cd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101cd8:	85 db                	test   %ebx,%ebx
80101cda:	74 34                	je     80101d10 <iunlockput+0x40>
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ce2:	56                   	push   %esi
80101ce3:	e8 58 29 00 00       	call   80104640 <holdingsleep>
80101ce8:	83 c4 10             	add    $0x10,%esp
80101ceb:	85 c0                	test   %eax,%eax
80101ced:	74 21                	je     80101d10 <iunlockput+0x40>
80101cef:	8b 43 08             	mov    0x8(%ebx),%eax
80101cf2:	85 c0                	test   %eax,%eax
80101cf4:	7e 1a                	jle    80101d10 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101cf6:	83 ec 0c             	sub    $0xc,%esp
80101cf9:	56                   	push   %esi
80101cfa:	e8 01 29 00 00       	call   80104600 <releasesleep>
  iput(ip);
80101cff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d02:	83 c4 10             	add    $0x10,%esp
}
80101d05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d08:	5b                   	pop    %ebx
80101d09:	5e                   	pop    %esi
80101d0a:	5d                   	pop    %ebp
  iput(ip);
80101d0b:	e9 60 fe ff ff       	jmp    80101b70 <iput>
    panic("iunlock");
80101d10:	83 ec 0c             	sub    $0xc,%esp
80101d13:	68 d7 75 10 80       	push   $0x801075d7
80101d18:	e8 63 e6 ff ff       	call   80100380 <panic>
80101d1d:	8d 76 00             	lea    0x0(%esi),%esi

80101d20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	8b 55 08             	mov    0x8(%ebp),%edx
80101d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d29:	8b 0a                	mov    (%edx),%ecx
80101d2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d43:	8b 52 58             	mov    0x58(%edx),%edx
80101d46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop

80101d50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5f:	8b 75 10             	mov    0x10(%ebp),%esi
80101d62:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d65:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d68:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101d73:	0f 84 a7 00 00 00    	je     80101e20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d7c:	8b 40 58             	mov    0x58(%eax),%eax
80101d7f:	39 c6                	cmp    %eax,%esi
80101d81:	0f 87 ba 00 00 00    	ja     80101e41 <readi+0xf1>
80101d87:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d8a:	31 c9                	xor    %ecx,%ecx
80101d8c:	89 da                	mov    %ebx,%edx
80101d8e:	01 f2                	add    %esi,%edx
80101d90:	0f 92 c1             	setb   %cl
80101d93:	89 cf                	mov    %ecx,%edi
80101d95:	0f 82 a6 00 00 00    	jb     80101e41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d9b:	89 c1                	mov    %eax,%ecx
80101d9d:	29 f1                	sub    %esi,%ecx
80101d9f:	39 d0                	cmp    %edx,%eax
80101da1:	0f 43 cb             	cmovae %ebx,%ecx
80101da4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da7:	85 c9                	test   %ecx,%ecx
80101da9:	74 67                	je     80101e12 <readi+0xc2>
80101dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101db0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101db3:	89 f2                	mov    %esi,%edx
80101db5:	c1 ea 09             	shr    $0x9,%edx
80101db8:	89 d8                	mov    %ebx,%eax
80101dba:	e8 51 f9 ff ff       	call   80101710 <bmap>
80101dbf:	83 ec 08             	sub    $0x8,%esp
80101dc2:	50                   	push   %eax
80101dc3:	ff 33                	push   (%ebx)
80101dc5:	e8 06 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101dcd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101dd4:	89 f0                	mov    %esi,%eax
80101dd6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ddb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ddd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101de0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101de2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101de6:	39 d9                	cmp    %ebx,%ecx
80101de8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101deb:	83 c4 0c             	add    $0xc,%esp
80101dee:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101def:	01 df                	add    %ebx,%edi
80101df1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101df3:	50                   	push   %eax
80101df4:	ff 75 e0             	push   -0x20(%ebp)
80101df7:	e8 c4 2b 00 00       	call   801049c0 <memmove>
    brelse(bp);
80101dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dff:	89 14 24             	mov    %edx,(%esp)
80101e02:	e8 e9 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e10:	77 9e                	ja     80101db0 <readi+0x60>
  }
  return n;
80101e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e18:	5b                   	pop    %ebx
80101e19:	5e                   	pop    %esi
80101e1a:	5f                   	pop    %edi
80101e1b:	5d                   	pop    %ebp
80101e1c:	c3                   	ret    
80101e1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e24:	66 83 f8 09          	cmp    $0x9,%ax
80101e28:	77 17                	ja     80101e41 <readi+0xf1>
80101e2a:	8b 04 c5 a0 f9 10 80 	mov    -0x7fef0660(,%eax,8),%eax
80101e31:	85 c0                	test   %eax,%eax
80101e33:	74 0c                	je     80101e41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e3b:	5b                   	pop    %ebx
80101e3c:	5e                   	pop    %esi
80101e3d:	5f                   	pop    %edi
80101e3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e3f:	ff e0                	jmp    *%eax
      return -1;
80101e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e46:	eb cd                	jmp    80101e15 <readi+0xc5>
80101e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4f:	90                   	nop

80101e50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 1c             	sub    $0x1c,%esp
80101e59:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e5f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101e73:	0f 84 b7 00 00 00    	je     80101f30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e7f:	0f 87 e7 00 00 00    	ja     80101f6c <writei+0x11c>
80101e85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e88:	31 d2                	xor    %edx,%edx
80101e8a:	89 f8                	mov    %edi,%eax
80101e8c:	01 f0                	add    %esi,%eax
80101e8e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e91:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e96:	0f 87 d0 00 00 00    	ja     80101f6c <writei+0x11c>
80101e9c:	85 d2                	test   %edx,%edx
80101e9e:	0f 85 c8 00 00 00    	jne    80101f6c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101eab:	85 ff                	test   %edi,%edi
80101ead:	74 72                	je     80101f21 <writei+0xd1>
80101eaf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101eb3:	89 f2                	mov    %esi,%edx
80101eb5:	c1 ea 09             	shr    $0x9,%edx
80101eb8:	89 f8                	mov    %edi,%eax
80101eba:	e8 51 f8 ff ff       	call   80101710 <bmap>
80101ebf:	83 ec 08             	sub    $0x8,%esp
80101ec2:	50                   	push   %eax
80101ec3:	ff 37                	push   (%edi)
80101ec5:	e8 06 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101eca:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ecf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ed2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ed5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ed7:	89 f0                	mov    %esi,%eax
80101ed9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ede:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ee0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ee4:	39 d9                	cmp    %ebx,%ecx
80101ee6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ee9:	83 c4 0c             	add    $0xc,%esp
80101eec:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101eed:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101eef:	ff 75 dc             	push   -0x24(%ebp)
80101ef2:	50                   	push   %eax
80101ef3:	e8 c8 2a 00 00       	call   801049c0 <memmove>
    log_write(bp);
80101ef8:	89 3c 24             	mov    %edi,(%esp)
80101efb:	e8 00 13 00 00       	call   80103200 <log_write>
    brelse(bp);
80101f00:	89 3c 24             	mov    %edi,(%esp)
80101f03:	e8 e8 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f0b:	83 c4 10             	add    $0x10,%esp
80101f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f11:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f14:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f17:	77 97                	ja     80101eb0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f1f:	77 37                	ja     80101f58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f27:	5b                   	pop    %ebx
80101f28:	5e                   	pop    %esi
80101f29:	5f                   	pop    %edi
80101f2a:	5d                   	pop    %ebp
80101f2b:	c3                   	ret    
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f34:	66 83 f8 09          	cmp    $0x9,%ax
80101f38:	77 32                	ja     80101f6c <writei+0x11c>
80101f3a:	8b 04 c5 a4 f9 10 80 	mov    -0x7fef065c(,%eax,8),%eax
80101f41:	85 c0                	test   %eax,%eax
80101f43:	74 27                	je     80101f6c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101f45:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4b:	5b                   	pop    %ebx
80101f4c:	5e                   	pop    %esi
80101f4d:	5f                   	pop    %edi
80101f4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101f4f:	ff e0                	jmp    *%eax
80101f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f61:	50                   	push   %eax
80101f62:	e8 29 fa ff ff       	call   80101990 <iupdate>
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	eb b5                	jmp    80101f21 <writei+0xd1>
      return -1;
80101f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f71:	eb b1                	jmp    80101f24 <writei+0xd4>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f80:	55                   	push   %ebp
80101f81:	89 e5                	mov    %esp,%ebp
80101f83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f86:	6a 0e                	push   $0xe
80101f88:	ff 75 0c             	push   0xc(%ebp)
80101f8b:	ff 75 08             	push   0x8(%ebp)
80101f8e:	e8 9d 2a 00 00       	call   80104a30 <strncmp>
}
80101f93:	c9                   	leave  
80101f94:	c3                   	ret    
80101f95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fa0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	83 ec 1c             	sub    $0x1c,%esp
80101fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101fac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101fb1:	0f 85 85 00 00 00    	jne    8010203c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101fb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101fba:	31 ff                	xor    %edi,%edi
80101fbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fbf:	85 d2                	test   %edx,%edx
80101fc1:	74 3e                	je     80102001 <dirlookup+0x61>
80101fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc8:	6a 10                	push   $0x10
80101fca:	57                   	push   %edi
80101fcb:	56                   	push   %esi
80101fcc:	53                   	push   %ebx
80101fcd:	e8 7e fd ff ff       	call   80101d50 <readi>
80101fd2:	83 c4 10             	add    $0x10,%esp
80101fd5:	83 f8 10             	cmp    $0x10,%eax
80101fd8:	75 55                	jne    8010202f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101fda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fdf:	74 18                	je     80101ff9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101fe1:	83 ec 04             	sub    $0x4,%esp
80101fe4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fe7:	6a 0e                	push   $0xe
80101fe9:	50                   	push   %eax
80101fea:	ff 75 0c             	push   0xc(%ebp)
80101fed:	e8 3e 2a 00 00       	call   80104a30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ff2:	83 c4 10             	add    $0x10,%esp
80101ff5:	85 c0                	test   %eax,%eax
80101ff7:	74 17                	je     80102010 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ff9:	83 c7 10             	add    $0x10,%edi
80101ffc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fff:	72 c7                	jb     80101fc8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102001:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102004:	31 c0                	xor    %eax,%eax
}
80102006:	5b                   	pop    %ebx
80102007:	5e                   	pop    %esi
80102008:	5f                   	pop    %edi
80102009:	5d                   	pop    %ebp
8010200a:	c3                   	ret    
8010200b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010200f:	90                   	nop
      if(poff)
80102010:	8b 45 10             	mov    0x10(%ebp),%eax
80102013:	85 c0                	test   %eax,%eax
80102015:	74 05                	je     8010201c <dirlookup+0x7c>
        *poff = off;
80102017:	8b 45 10             	mov    0x10(%ebp),%eax
8010201a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010201c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102020:	8b 03                	mov    (%ebx),%eax
80102022:	e8 e9 f5 ff ff       	call   80101610 <iget>
}
80102027:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202a:	5b                   	pop    %ebx
8010202b:	5e                   	pop    %esi
8010202c:	5f                   	pop    %edi
8010202d:	5d                   	pop    %ebp
8010202e:	c3                   	ret    
      panic("dirlookup read");
8010202f:	83 ec 0c             	sub    $0xc,%esp
80102032:	68 f1 75 10 80       	push   $0x801075f1
80102037:	e8 44 e3 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010203c:	83 ec 0c             	sub    $0xc,%esp
8010203f:	68 df 75 10 80       	push   $0x801075df
80102044:	e8 37 e3 ff ff       	call   80100380 <panic>
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	89 c3                	mov    %eax,%ebx
80102058:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010205b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010205e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102061:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102064:	0f 84 64 01 00 00    	je     801021ce <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010206a:	e8 c1 1b 00 00       	call   80103c30 <myproc>
  acquire(&icache.lock);
8010206f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102072:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102075:	68 00 fa 10 80       	push   $0x8010fa00
8010207a:	e8 e1 27 00 00       	call   80104860 <acquire>
  ip->ref++;
8010207f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102083:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
8010208a:	e8 71 27 00 00       	call   80104800 <release>
8010208f:	83 c4 10             	add    $0x10,%esp
80102092:	eb 07                	jmp    8010209b <namex+0x4b>
80102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102098:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010209b:	0f b6 03             	movzbl (%ebx),%eax
8010209e:	3c 2f                	cmp    $0x2f,%al
801020a0:	74 f6                	je     80102098 <namex+0x48>
  if(*path == 0)
801020a2:	84 c0                	test   %al,%al
801020a4:	0f 84 06 01 00 00    	je     801021b0 <namex+0x160>
  while(*path != '/' && *path != 0)
801020aa:	0f b6 03             	movzbl (%ebx),%eax
801020ad:	84 c0                	test   %al,%al
801020af:	0f 84 10 01 00 00    	je     801021c5 <namex+0x175>
801020b5:	89 df                	mov    %ebx,%edi
801020b7:	3c 2f                	cmp    $0x2f,%al
801020b9:	0f 84 06 01 00 00    	je     801021c5 <namex+0x175>
801020bf:	90                   	nop
801020c0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801020c4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801020c7:	3c 2f                	cmp    $0x2f,%al
801020c9:	74 04                	je     801020cf <namex+0x7f>
801020cb:	84 c0                	test   %al,%al
801020cd:	75 f1                	jne    801020c0 <namex+0x70>
  len = path - s;
801020cf:	89 f8                	mov    %edi,%eax
801020d1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801020d3:	83 f8 0d             	cmp    $0xd,%eax
801020d6:	0f 8e ac 00 00 00    	jle    80102188 <namex+0x138>
    memmove(name, s, DIRSIZ);
801020dc:	83 ec 04             	sub    $0x4,%esp
801020df:	6a 0e                	push   $0xe
801020e1:	53                   	push   %ebx
    path++;
801020e2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801020e4:	ff 75 e4             	push   -0x1c(%ebp)
801020e7:	e8 d4 28 00 00       	call   801049c0 <memmove>
801020ec:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801020ef:	80 3f 2f             	cmpb   $0x2f,(%edi)
801020f2:	75 0c                	jne    80102100 <namex+0xb0>
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801020f8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020fb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020fe:	74 f8                	je     801020f8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	56                   	push   %esi
80102104:	e8 37 f9 ff ff       	call   80101a40 <ilock>
    if(ip->type != T_DIR){
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102111:	0f 85 cd 00 00 00    	jne    801021e4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102117:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010211a:	85 c0                	test   %eax,%eax
8010211c:	74 09                	je     80102127 <namex+0xd7>
8010211e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102121:	0f 84 22 01 00 00    	je     80102249 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102127:	83 ec 04             	sub    $0x4,%esp
8010212a:	6a 00                	push   $0x0
8010212c:	ff 75 e4             	push   -0x1c(%ebp)
8010212f:	56                   	push   %esi
80102130:	e8 6b fe ff ff       	call   80101fa0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102135:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	89 c7                	mov    %eax,%edi
8010213d:	85 c0                	test   %eax,%eax
8010213f:	0f 84 e1 00 00 00    	je     80102226 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010214b:	52                   	push   %edx
8010214c:	e8 ef 24 00 00       	call   80104640 <holdingsleep>
80102151:	83 c4 10             	add    $0x10,%esp
80102154:	85 c0                	test   %eax,%eax
80102156:	0f 84 30 01 00 00    	je     8010228c <namex+0x23c>
8010215c:	8b 56 08             	mov    0x8(%esi),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	0f 8e 25 01 00 00    	jle    8010228c <namex+0x23c>
  releasesleep(&ip->lock);
80102167:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010216a:	83 ec 0c             	sub    $0xc,%esp
8010216d:	52                   	push   %edx
8010216e:	e8 8d 24 00 00       	call   80104600 <releasesleep>
  iput(ip);
80102173:	89 34 24             	mov    %esi,(%esp)
80102176:	89 fe                	mov    %edi,%esi
80102178:	e8 f3 f9 ff ff       	call   80101b70 <iput>
8010217d:	83 c4 10             	add    $0x10,%esp
80102180:	e9 16 ff ff ff       	jmp    8010209b <namex+0x4b>
80102185:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102188:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010218b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010218e:	83 ec 04             	sub    $0x4,%esp
80102191:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102194:	50                   	push   %eax
80102195:	53                   	push   %ebx
    name[len] = 0;
80102196:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102198:	ff 75 e4             	push   -0x1c(%ebp)
8010219b:	e8 20 28 00 00       	call   801049c0 <memmove>
    name[len] = 0;
801021a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021a3:	83 c4 10             	add    $0x10,%esp
801021a6:	c6 02 00             	movb   $0x0,(%edx)
801021a9:	e9 41 ff ff ff       	jmp    801020ef <namex+0x9f>
801021ae:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801021b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801021b3:	85 c0                	test   %eax,%eax
801021b5:	0f 85 be 00 00 00    	jne    80102279 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801021bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021be:	89 f0                	mov    %esi,%eax
801021c0:	5b                   	pop    %ebx
801021c1:	5e                   	pop    %esi
801021c2:	5f                   	pop    %edi
801021c3:	5d                   	pop    %ebp
801021c4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801021c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801021c8:	89 df                	mov    %ebx,%edi
801021ca:	31 c0                	xor    %eax,%eax
801021cc:	eb c0                	jmp    8010218e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801021ce:	ba 01 00 00 00       	mov    $0x1,%edx
801021d3:	b8 01 00 00 00       	mov    $0x1,%eax
801021d8:	e8 33 f4 ff ff       	call   80101610 <iget>
801021dd:	89 c6                	mov    %eax,%esi
801021df:	e9 b7 fe ff ff       	jmp    8010209b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021e4:	83 ec 0c             	sub    $0xc,%esp
801021e7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801021ea:	53                   	push   %ebx
801021eb:	e8 50 24 00 00       	call   80104640 <holdingsleep>
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	85 c0                	test   %eax,%eax
801021f5:	0f 84 91 00 00 00    	je     8010228c <namex+0x23c>
801021fb:	8b 46 08             	mov    0x8(%esi),%eax
801021fe:	85 c0                	test   %eax,%eax
80102200:	0f 8e 86 00 00 00    	jle    8010228c <namex+0x23c>
  releasesleep(&ip->lock);
80102206:	83 ec 0c             	sub    $0xc,%esp
80102209:	53                   	push   %ebx
8010220a:	e8 f1 23 00 00       	call   80104600 <releasesleep>
  iput(ip);
8010220f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102212:	31 f6                	xor    %esi,%esi
  iput(ip);
80102214:	e8 57 f9 ff ff       	call   80101b70 <iput>
      return 0;
80102219:	83 c4 10             	add    $0x10,%esp
}
8010221c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221f:	89 f0                	mov    %esi,%eax
80102221:	5b                   	pop    %ebx
80102222:	5e                   	pop    %esi
80102223:	5f                   	pop    %edi
80102224:	5d                   	pop    %ebp
80102225:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010222c:	52                   	push   %edx
8010222d:	e8 0e 24 00 00       	call   80104640 <holdingsleep>
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	85 c0                	test   %eax,%eax
80102237:	74 53                	je     8010228c <namex+0x23c>
80102239:	8b 4e 08             	mov    0x8(%esi),%ecx
8010223c:	85 c9                	test   %ecx,%ecx
8010223e:	7e 4c                	jle    8010228c <namex+0x23c>
  releasesleep(&ip->lock);
80102240:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102243:	83 ec 0c             	sub    $0xc,%esp
80102246:	52                   	push   %edx
80102247:	eb c1                	jmp    8010220a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010224f:	53                   	push   %ebx
80102250:	e8 eb 23 00 00       	call   80104640 <holdingsleep>
80102255:	83 c4 10             	add    $0x10,%esp
80102258:	85 c0                	test   %eax,%eax
8010225a:	74 30                	je     8010228c <namex+0x23c>
8010225c:	8b 7e 08             	mov    0x8(%esi),%edi
8010225f:	85 ff                	test   %edi,%edi
80102261:	7e 29                	jle    8010228c <namex+0x23c>
  releasesleep(&ip->lock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	53                   	push   %ebx
80102267:	e8 94 23 00 00       	call   80104600 <releasesleep>
}
8010226c:	83 c4 10             	add    $0x10,%esp
}
8010226f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102272:	89 f0                	mov    %esi,%eax
80102274:	5b                   	pop    %ebx
80102275:	5e                   	pop    %esi
80102276:	5f                   	pop    %edi
80102277:	5d                   	pop    %ebp
80102278:	c3                   	ret    
    iput(ip);
80102279:	83 ec 0c             	sub    $0xc,%esp
8010227c:	56                   	push   %esi
    return 0;
8010227d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010227f:	e8 ec f8 ff ff       	call   80101b70 <iput>
    return 0;
80102284:	83 c4 10             	add    $0x10,%esp
80102287:	e9 2f ff ff ff       	jmp    801021bb <namex+0x16b>
    panic("iunlock");
8010228c:	83 ec 0c             	sub    $0xc,%esp
8010228f:	68 d7 75 10 80       	push   $0x801075d7
80102294:	e8 e7 e0 ff ff       	call   80100380 <panic>
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <dirlink>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 20             	sub    $0x20,%esp
801022a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801022ac:	6a 00                	push   $0x0
801022ae:	ff 75 0c             	push   0xc(%ebp)
801022b1:	53                   	push   %ebx
801022b2:	e8 e9 fc ff ff       	call   80101fa0 <dirlookup>
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	75 67                	jne    80102325 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022be:	8b 7b 58             	mov    0x58(%ebx),%edi
801022c1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801022c4:	85 ff                	test   %edi,%edi
801022c6:	74 29                	je     801022f1 <dirlink+0x51>
801022c8:	31 ff                	xor    %edi,%edi
801022ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
801022cd:	eb 09                	jmp    801022d8 <dirlink+0x38>
801022cf:	90                   	nop
801022d0:	83 c7 10             	add    $0x10,%edi
801022d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022d6:	73 19                	jae    801022f1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d8:	6a 10                	push   $0x10
801022da:	57                   	push   %edi
801022db:	56                   	push   %esi
801022dc:	53                   	push   %ebx
801022dd:	e8 6e fa ff ff       	call   80101d50 <readi>
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	83 f8 10             	cmp    $0x10,%eax
801022e8:	75 4e                	jne    80102338 <dirlink+0x98>
    if(de.inum == 0)
801022ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022ef:	75 df                	jne    801022d0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801022f1:	83 ec 04             	sub    $0x4,%esp
801022f4:	8d 45 da             	lea    -0x26(%ebp),%eax
801022f7:	6a 0e                	push   $0xe
801022f9:	ff 75 0c             	push   0xc(%ebp)
801022fc:	50                   	push   %eax
801022fd:	e8 7e 27 00 00       	call   80104a80 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102302:	6a 10                	push   $0x10
  de.inum = inum;
80102304:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102307:	57                   	push   %edi
80102308:	56                   	push   %esi
80102309:	53                   	push   %ebx
  de.inum = inum;
8010230a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010230e:	e8 3d fb ff ff       	call   80101e50 <writei>
80102313:	83 c4 20             	add    $0x20,%esp
80102316:	83 f8 10             	cmp    $0x10,%eax
80102319:	75 2a                	jne    80102345 <dirlink+0xa5>
  return 0;
8010231b:	31 c0                	xor    %eax,%eax
}
8010231d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102320:	5b                   	pop    %ebx
80102321:	5e                   	pop    %esi
80102322:	5f                   	pop    %edi
80102323:	5d                   	pop    %ebp
80102324:	c3                   	ret    
    iput(ip);
80102325:	83 ec 0c             	sub    $0xc,%esp
80102328:	50                   	push   %eax
80102329:	e8 42 f8 ff ff       	call   80101b70 <iput>
    return -1;
8010232e:	83 c4 10             	add    $0x10,%esp
80102331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102336:	eb e5                	jmp    8010231d <dirlink+0x7d>
      panic("dirlink read");
80102338:	83 ec 0c             	sub    $0xc,%esp
8010233b:	68 00 76 10 80       	push   $0x80107600
80102340:	e8 3b e0 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102345:	83 ec 0c             	sub    $0xc,%esp
80102348:	68 de 7b 10 80       	push   $0x80107bde
8010234d:	e8 2e e0 ff ff       	call   80100380 <panic>
80102352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102360 <namei>:

struct inode*
namei(char *path)
{
80102360:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102361:	31 d2                	xor    %edx,%edx
{
80102363:	89 e5                	mov    %esp,%ebp
80102365:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102368:	8b 45 08             	mov    0x8(%ebp),%eax
8010236b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010236e:	e8 dd fc ff ff       	call   80102050 <namex>
}
80102373:	c9                   	leave  
80102374:	c3                   	ret    
80102375:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102380 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102380:	55                   	push   %ebp
  return namex(path, 1, name);
80102381:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102386:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102388:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010238b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010238e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010238f:	e9 bc fc ff ff       	jmp    80102050 <namex>
80102394:	66 90                	xchg   %ax,%ax
80102396:	66 90                	xchg   %ax,%ax
80102398:	66 90                	xchg   %ax,%ax
8010239a:	66 90                	xchg   %ax,%ax
8010239c:	66 90                	xchg   %ax,%ax
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	57                   	push   %edi
801023a4:	56                   	push   %esi
801023a5:	53                   	push   %ebx
801023a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023a9:	85 c0                	test   %eax,%eax
801023ab:	0f 84 b4 00 00 00    	je     80102465 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801023b1:	8b 70 08             	mov    0x8(%eax),%esi
801023b4:	89 c3                	mov    %eax,%ebx
801023b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801023bc:	0f 87 96 00 00 00    	ja     80102458 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801023c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ce:	66 90                	xchg   %ax,%ax
801023d0:	89 ca                	mov    %ecx,%edx
801023d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d3:	83 e0 c0             	and    $0xffffffc0,%eax
801023d6:	3c 40                	cmp    $0x40,%al
801023d8:	75 f6                	jne    801023d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023da:	31 ff                	xor    %edi,%edi
801023dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801023e1:	89 f8                	mov    %edi,%eax
801023e3:	ee                   	out    %al,(%dx)
801023e4:	b8 01 00 00 00       	mov    $0x1,%eax
801023e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801023ee:	ee                   	out    %al,(%dx)
801023ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023f4:	89 f0                	mov    %esi,%eax
801023f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023f7:	89 f0                	mov    %esi,%eax
801023f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023fe:	c1 f8 08             	sar    $0x8,%eax
80102401:	ee                   	out    %al,(%dx)
80102402:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102407:	89 f8                	mov    %edi,%eax
80102409:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010240a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010240e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102413:	c1 e0 04             	shl    $0x4,%eax
80102416:	83 e0 10             	and    $0x10,%eax
80102419:	83 c8 e0             	or     $0xffffffe0,%eax
8010241c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010241d:	f6 03 04             	testb  $0x4,(%ebx)
80102420:	75 16                	jne    80102438 <idestart+0x98>
80102422:	b8 20 00 00 00       	mov    $0x20,%eax
80102427:	89 ca                	mov    %ecx,%edx
80102429:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010242a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010242d:	5b                   	pop    %ebx
8010242e:	5e                   	pop    %esi
8010242f:	5f                   	pop    %edi
80102430:	5d                   	pop    %ebp
80102431:	c3                   	ret    
80102432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102438:	b8 30 00 00 00       	mov    $0x30,%eax
8010243d:	89 ca                	mov    %ecx,%edx
8010243f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102440:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102445:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102448:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010244d:	fc                   	cld    
8010244e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102453:	5b                   	pop    %ebx
80102454:	5e                   	pop    %esi
80102455:	5f                   	pop    %edi
80102456:	5d                   	pop    %ebp
80102457:	c3                   	ret    
    panic("incorrect blockno");
80102458:	83 ec 0c             	sub    $0xc,%esp
8010245b:	68 6c 76 10 80       	push   $0x8010766c
80102460:	e8 1b df ff ff       	call   80100380 <panic>
    panic("idestart");
80102465:	83 ec 0c             	sub    $0xc,%esp
80102468:	68 63 76 10 80       	push   $0x80107663
8010246d:	e8 0e df ff ff       	call   80100380 <panic>
80102472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102480 <ideinit>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102486:	68 7e 76 10 80       	push   $0x8010767e
8010248b:	68 a0 16 11 80       	push   $0x801116a0
80102490:	e8 fb 21 00 00       	call   80104690 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102495:	58                   	pop    %eax
80102496:	a1 24 18 11 80       	mov    0x80111824,%eax
8010249b:	5a                   	pop    %edx
8010249c:	83 e8 01             	sub    $0x1,%eax
8010249f:	50                   	push   %eax
801024a0:	6a 0e                	push   $0xe
801024a2:	e8 99 02 00 00       	call   80102740 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024af:	90                   	nop
801024b0:	ec                   	in     (%dx),%al
801024b1:	83 e0 c0             	and    $0xffffffc0,%eax
801024b4:	3c 40                	cmp    $0x40,%al
801024b6:	75 f8                	jne    801024b0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801024bd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024c2:	ee                   	out    %al,(%dx)
801024c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024cd:	eb 06                	jmp    801024d5 <ideinit+0x55>
801024cf:	90                   	nop
  for(i=0; i<1000; i++){
801024d0:	83 e9 01             	sub    $0x1,%ecx
801024d3:	74 0f                	je     801024e4 <ideinit+0x64>
801024d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801024d6:	84 c0                	test   %al,%al
801024d8:	74 f6                	je     801024d0 <ideinit+0x50>
      havedisk1 = 1;
801024da:	c7 05 80 16 11 80 01 	movl   $0x1,0x80111680
801024e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801024e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024ee:	ee                   	out    %al,(%dx)
}
801024ef:	c9                   	leave  
801024f0:	c3                   	ret    
801024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop

80102500 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	57                   	push   %edi
80102504:	56                   	push   %esi
80102505:	53                   	push   %ebx
80102506:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102509:	68 a0 16 11 80       	push   $0x801116a0
8010250e:	e8 4d 23 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
80102513:	8b 1d 84 16 11 80    	mov    0x80111684,%ebx
80102519:	83 c4 10             	add    $0x10,%esp
8010251c:	85 db                	test   %ebx,%ebx
8010251e:	74 63                	je     80102583 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102520:	8b 43 58             	mov    0x58(%ebx),%eax
80102523:	a3 84 16 11 80       	mov    %eax,0x80111684

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102528:	8b 33                	mov    (%ebx),%esi
8010252a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102530:	75 2f                	jne    80102561 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102532:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253e:	66 90                	xchg   %ax,%ax
80102540:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102541:	89 c1                	mov    %eax,%ecx
80102543:	83 e1 c0             	and    $0xffffffc0,%ecx
80102546:	80 f9 40             	cmp    $0x40,%cl
80102549:	75 f5                	jne    80102540 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010254b:	a8 21                	test   $0x21,%al
8010254d:	75 12                	jne    80102561 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010254f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102552:	b9 80 00 00 00       	mov    $0x80,%ecx
80102557:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010255c:	fc                   	cld    
8010255d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010255f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102561:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102564:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102567:	83 ce 02             	or     $0x2,%esi
8010256a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010256c:	53                   	push   %ebx
8010256d:	e8 4e 1e 00 00       	call   801043c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102572:	a1 84 16 11 80       	mov    0x80111684,%eax
80102577:	83 c4 10             	add    $0x10,%esp
8010257a:	85 c0                	test   %eax,%eax
8010257c:	74 05                	je     80102583 <ideintr+0x83>
    idestart(idequeue);
8010257e:	e8 1d fe ff ff       	call   801023a0 <idestart>
    release(&idelock);
80102583:	83 ec 0c             	sub    $0xc,%esp
80102586:	68 a0 16 11 80       	push   $0x801116a0
8010258b:	e8 70 22 00 00       	call   80104800 <release>

  release(&idelock);
}
80102590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102593:	5b                   	pop    %ebx
80102594:	5e                   	pop    %esi
80102595:	5f                   	pop    %edi
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop

801025a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 10             	sub    $0x10,%esp
801025a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801025aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801025ad:	50                   	push   %eax
801025ae:	e8 8d 20 00 00       	call   80104640 <holdingsleep>
801025b3:	83 c4 10             	add    $0x10,%esp
801025b6:	85 c0                	test   %eax,%eax
801025b8:	0f 84 c3 00 00 00    	je     80102681 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801025be:	8b 03                	mov    (%ebx),%eax
801025c0:	83 e0 06             	and    $0x6,%eax
801025c3:	83 f8 02             	cmp    $0x2,%eax
801025c6:	0f 84 a8 00 00 00    	je     80102674 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801025cc:	8b 53 04             	mov    0x4(%ebx),%edx
801025cf:	85 d2                	test   %edx,%edx
801025d1:	74 0d                	je     801025e0 <iderw+0x40>
801025d3:	a1 80 16 11 80       	mov    0x80111680,%eax
801025d8:	85 c0                	test   %eax,%eax
801025da:	0f 84 87 00 00 00    	je     80102667 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801025e0:	83 ec 0c             	sub    $0xc,%esp
801025e3:	68 a0 16 11 80       	push   $0x801116a0
801025e8:	e8 73 22 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025ed:	a1 84 16 11 80       	mov    0x80111684,%eax
  b->qnext = 0;
801025f2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025f9:	83 c4 10             	add    $0x10,%esp
801025fc:	85 c0                	test   %eax,%eax
801025fe:	74 60                	je     80102660 <iderw+0xc0>
80102600:	89 c2                	mov    %eax,%edx
80102602:	8b 40 58             	mov    0x58(%eax),%eax
80102605:	85 c0                	test   %eax,%eax
80102607:	75 f7                	jne    80102600 <iderw+0x60>
80102609:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010260c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010260e:	39 1d 84 16 11 80    	cmp    %ebx,0x80111684
80102614:	74 3a                	je     80102650 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102616:	8b 03                	mov    (%ebx),%eax
80102618:	83 e0 06             	and    $0x6,%eax
8010261b:	83 f8 02             	cmp    $0x2,%eax
8010261e:	74 1b                	je     8010263b <iderw+0x9b>
    sleep(b, &idelock);
80102620:	83 ec 08             	sub    $0x8,%esp
80102623:	68 a0 16 11 80       	push   $0x801116a0
80102628:	53                   	push   %ebx
80102629:	e8 d2 1c 00 00       	call   80104300 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010262e:	8b 03                	mov    (%ebx),%eax
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	83 e0 06             	and    $0x6,%eax
80102636:	83 f8 02             	cmp    $0x2,%eax
80102639:	75 e5                	jne    80102620 <iderw+0x80>
  }


  release(&idelock);
8010263b:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102645:	c9                   	leave  
  release(&idelock);
80102646:	e9 b5 21 00 00       	jmp    80104800 <release>
8010264b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop
    idestart(b);
80102650:	89 d8                	mov    %ebx,%eax
80102652:	e8 49 fd ff ff       	call   801023a0 <idestart>
80102657:	eb bd                	jmp    80102616 <iderw+0x76>
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102660:	ba 84 16 11 80       	mov    $0x80111684,%edx
80102665:	eb a5                	jmp    8010260c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102667:	83 ec 0c             	sub    $0xc,%esp
8010266a:	68 ad 76 10 80       	push   $0x801076ad
8010266f:	e8 0c dd ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102674:	83 ec 0c             	sub    $0xc,%esp
80102677:	68 98 76 10 80       	push   $0x80107698
8010267c:	e8 ff dc ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102681:	83 ec 0c             	sub    $0xc,%esp
80102684:	68 82 76 10 80       	push   $0x80107682
80102689:	e8 f2 dc ff ff       	call   80100380 <panic>
8010268e:	66 90                	xchg   %ax,%ax

80102690 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102690:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102691:	c7 05 d4 16 11 80 00 	movl   $0xfec00000,0x801116d4
80102698:	00 c0 fe 
{
8010269b:	89 e5                	mov    %esp,%ebp
8010269d:	56                   	push   %esi
8010269e:	53                   	push   %ebx
  ioapic->reg = reg;
8010269f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801026a6:	00 00 00 
  return ioapic->data;
801026a9:	8b 15 d4 16 11 80    	mov    0x801116d4,%edx
801026af:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801026b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801026b8:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801026be:	0f b6 15 20 18 11 80 	movzbl 0x80111820,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026c5:	c1 ee 10             	shr    $0x10,%esi
801026c8:	89 f0                	mov    %esi,%eax
801026ca:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801026cd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801026d0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026d3:	39 c2                	cmp    %eax,%edx
801026d5:	74 16                	je     801026ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026d7:	83 ec 0c             	sub    $0xc,%esp
801026da:	68 cc 76 10 80       	push   $0x801076cc
801026df:	e8 bc df ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
801026e4:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
801026ea:	83 c4 10             	add    $0x10,%esp
801026ed:	83 c6 21             	add    $0x21,%esi
{
801026f0:	ba 10 00 00 00       	mov    $0x10,%edx
801026f5:	b8 20 00 00 00       	mov    $0x20,%eax
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102700:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102702:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102704:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  for(i = 0; i <= maxintr; i++){
8010270a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010270d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102713:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102716:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102719:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010271c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010271e:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
80102724:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010272b:	39 f0                	cmp    %esi,%eax
8010272d:	75 d1                	jne    80102700 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010272f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102732:	5b                   	pop    %ebx
80102733:	5e                   	pop    %esi
80102734:	5d                   	pop    %ebp
80102735:	c3                   	ret    
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102740:	55                   	push   %ebp
  ioapic->reg = reg;
80102741:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
{
80102747:	89 e5                	mov    %esp,%ebp
80102749:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010274c:	8d 50 20             	lea    0x20(%eax),%edx
8010274f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102753:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102755:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010275b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010275e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102761:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102764:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102766:	a1 d4 16 11 80       	mov    0x801116d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010276b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010276e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102771:	5d                   	pop    %ebp
80102772:	c3                   	ret    
80102773:	66 90                	xchg   %ax,%ax
80102775:	66 90                	xchg   %ax,%ax
80102777:	66 90                	xchg   %ax,%ax
80102779:	66 90                	xchg   %ax,%ax
8010277b:	66 90                	xchg   %ax,%ax
8010277d:	66 90                	xchg   %ax,%ax
8010277f:	90                   	nop

80102780 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	53                   	push   %ebx
80102784:	83 ec 04             	sub    $0x4,%esp
80102787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010278a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102790:	75 76                	jne    80102808 <kfree+0x88>
80102792:	81 fb 70 55 11 80    	cmp    $0x80115570,%ebx
80102798:	72 6e                	jb     80102808 <kfree+0x88>
8010279a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027a5:	77 61                	ja     80102808 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027a7:	83 ec 04             	sub    $0x4,%esp
801027aa:	68 00 10 00 00       	push   $0x1000
801027af:	6a 01                	push   $0x1
801027b1:	53                   	push   %ebx
801027b2:	e8 69 21 00 00       	call   80104920 <memset>

  if(kmem.use_lock)
801027b7:	8b 15 14 17 11 80    	mov    0x80111714,%edx
801027bd:	83 c4 10             	add    $0x10,%esp
801027c0:	85 d2                	test   %edx,%edx
801027c2:	75 1c                	jne    801027e0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027c4:	a1 18 17 11 80       	mov    0x80111718,%eax
801027c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027cb:	a1 14 17 11 80       	mov    0x80111714,%eax
  kmem.freelist = r;
801027d0:	89 1d 18 17 11 80    	mov    %ebx,0x80111718
  if(kmem.use_lock)
801027d6:	85 c0                	test   %eax,%eax
801027d8:	75 1e                	jne    801027f8 <kfree+0x78>
    release(&kmem.lock);
}
801027da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027dd:	c9                   	leave  
801027de:	c3                   	ret    
801027df:	90                   	nop
    acquire(&kmem.lock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 e0 16 11 80       	push   $0x801116e0
801027e8:	e8 73 20 00 00       	call   80104860 <acquire>
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	eb d2                	jmp    801027c4 <kfree+0x44>
801027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801027f8:	c7 45 08 e0 16 11 80 	movl   $0x801116e0,0x8(%ebp)
}
801027ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102802:	c9                   	leave  
    release(&kmem.lock);
80102803:	e9 f8 1f 00 00       	jmp    80104800 <release>
    panic("kfree");
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	68 fe 76 10 80       	push   $0x801076fe
80102810:	e8 6b db ff ff       	call   80100380 <panic>
80102815:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102820 <freerange>:
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102824:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102827:	8b 75 0c             	mov    0xc(%ebp),%esi
8010282a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010282b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102831:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102837:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010283d:	39 de                	cmp    %ebx,%esi
8010283f:	72 23                	jb     80102864 <freerange+0x44>
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102848:	83 ec 0c             	sub    $0xc,%esp
8010284b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102851:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102857:	50                   	push   %eax
80102858:	e8 23 ff ff ff       	call   80102780 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	39 f3                	cmp    %esi,%ebx
80102862:	76 e4                	jbe    80102848 <freerange+0x28>
}
80102864:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102867:	5b                   	pop    %ebx
80102868:	5e                   	pop    %esi
80102869:	5d                   	pop    %ebp
8010286a:	c3                   	ret    
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <kinit2>:
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102874:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102877:	8b 75 0c             	mov    0xc(%ebp),%esi
8010287a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010287b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102881:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102887:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010288d:	39 de                	cmp    %ebx,%esi
8010288f:	72 23                	jb     801028b4 <kinit2+0x44>
80102891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102898:	83 ec 0c             	sub    $0xc,%esp
8010289b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028a7:	50                   	push   %eax
801028a8:	e8 d3 fe ff ff       	call   80102780 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	39 de                	cmp    %ebx,%esi
801028b2:	73 e4                	jae    80102898 <kinit2+0x28>
  kmem.use_lock = 1;
801028b4:	c7 05 14 17 11 80 01 	movl   $0x1,0x80111714
801028bb:	00 00 00 
}
801028be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028c1:	5b                   	pop    %ebx
801028c2:	5e                   	pop    %esi
801028c3:	5d                   	pop    %ebp
801028c4:	c3                   	ret    
801028c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028d0 <kinit1>:
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
801028d3:	56                   	push   %esi
801028d4:	53                   	push   %ebx
801028d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028d8:	83 ec 08             	sub    $0x8,%esp
801028db:	68 04 77 10 80       	push   $0x80107704
801028e0:	68 e0 16 11 80       	push   $0x801116e0
801028e5:	e8 a6 1d 00 00       	call   80104690 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028f0:	c7 05 14 17 11 80 00 	movl   $0x0,0x80111714
801028f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102900:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102906:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010290c:	39 de                	cmp    %ebx,%esi
8010290e:	72 1c                	jb     8010292c <kinit1+0x5c>
    kfree(p);
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102919:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010291f:	50                   	push   %eax
80102920:	e8 5b fe ff ff       	call   80102780 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102925:	83 c4 10             	add    $0x10,%esp
80102928:	39 de                	cmp    %ebx,%esi
8010292a:	73 e4                	jae    80102910 <kinit1+0x40>
}
8010292c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010292f:	5b                   	pop    %ebx
80102930:	5e                   	pop    %esi
80102931:	5d                   	pop    %ebp
80102932:	c3                   	ret    
80102933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102940:	a1 14 17 11 80       	mov    0x80111714,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	75 1f                	jne    80102968 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102949:	a1 18 17 11 80       	mov    0x80111718,%eax
  if(r)
8010294e:	85 c0                	test   %eax,%eax
80102950:	74 0e                	je     80102960 <kalloc+0x20>
    kmem.freelist = r->next;
80102952:	8b 10                	mov    (%eax),%edx
80102954:	89 15 18 17 11 80    	mov    %edx,0x80111718
  if(kmem.use_lock)
8010295a:	c3                   	ret    
8010295b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102960:	c3                   	ret    
80102961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102968:	55                   	push   %ebp
80102969:	89 e5                	mov    %esp,%ebp
8010296b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010296e:	68 e0 16 11 80       	push   $0x801116e0
80102973:	e8 e8 1e 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
80102978:	a1 18 17 11 80       	mov    0x80111718,%eax
  if(kmem.use_lock)
8010297d:	8b 15 14 17 11 80    	mov    0x80111714,%edx
  if(r)
80102983:	83 c4 10             	add    $0x10,%esp
80102986:	85 c0                	test   %eax,%eax
80102988:	74 08                	je     80102992 <kalloc+0x52>
    kmem.freelist = r->next;
8010298a:	8b 08                	mov    (%eax),%ecx
8010298c:	89 0d 18 17 11 80    	mov    %ecx,0x80111718
  if(kmem.use_lock)
80102992:	85 d2                	test   %edx,%edx
80102994:	74 16                	je     801029ac <kalloc+0x6c>
    release(&kmem.lock);
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010299c:	68 e0 16 11 80       	push   $0x801116e0
801029a1:	e8 5a 1e 00 00       	call   80104800 <release>
  return (char*)r;
801029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029a9:	83 c4 10             	add    $0x10,%esp
}
801029ac:	c9                   	leave  
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b0:	ba 64 00 00 00       	mov    $0x64,%edx
801029b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029b6:	a8 01                	test   $0x1,%al
801029b8:	0f 84 c2 00 00 00    	je     80102a80 <kbdgetc+0xd0>
{
801029be:	55                   	push   %ebp
801029bf:	ba 60 00 00 00       	mov    $0x60,%edx
801029c4:	89 e5                	mov    %esp,%ebp
801029c6:	53                   	push   %ebx
801029c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801029c8:	8b 1d 1c 17 11 80    	mov    0x8011171c,%ebx
  data = inb(KBDATAP);
801029ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801029d1:	3c e0                	cmp    $0xe0,%al
801029d3:	74 5b                	je     80102a30 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801029d5:	89 da                	mov    %ebx,%edx
801029d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801029da:	84 c0                	test   %al,%al
801029dc:	78 62                	js     80102a40 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029de:	85 d2                	test   %edx,%edx
801029e0:	74 09                	je     801029eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801029e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801029eb:	0f b6 91 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%edx
  shift ^= togglecode[data];
801029f2:	0f b6 81 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%eax
  shift |= shiftcode[data];
801029f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801029fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801029fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801029ff:	89 15 1c 17 11 80    	mov    %edx,0x8011171c
  c = charcode[shift & (CTL | SHIFT)][data];
80102a05:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a08:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a0b:	8b 04 85 20 77 10 80 	mov    -0x7fef88e0(,%eax,4),%eax
80102a12:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102a16:	74 0b                	je     80102a23 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102a18:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a1b:	83 fa 19             	cmp    $0x19,%edx
80102a1e:	77 48                	ja     80102a68 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a20:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a26:	c9                   	leave  
80102a27:	c3                   	ret    
80102a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop
    shift |= E0ESC;
80102a30:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a33:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a35:	89 1d 1c 17 11 80    	mov    %ebx,0x8011171c
}
80102a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3e:	c9                   	leave  
80102a3f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102a40:	83 e0 7f             	and    $0x7f,%eax
80102a43:	85 d2                	test   %edx,%edx
80102a45:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102a48:	0f b6 81 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%eax
80102a4f:	83 c8 40             	or     $0x40,%eax
80102a52:	0f b6 c0             	movzbl %al,%eax
80102a55:	f7 d0                	not    %eax
80102a57:	21 d8                	and    %ebx,%eax
}
80102a59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102a5c:	a3 1c 17 11 80       	mov    %eax,0x8011171c
    return 0;
80102a61:	31 c0                	xor    %eax,%eax
}
80102a63:	c9                   	leave  
80102a64:	c3                   	ret    
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102a68:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a6b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a71:	c9                   	leave  
      c += 'a' - 'A';
80102a72:	83 f9 1a             	cmp    $0x1a,%ecx
80102a75:	0f 42 c2             	cmovb  %edx,%eax
}
80102a78:	c3                   	ret    
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a85:	c3                   	ret    
80102a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8d:	8d 76 00             	lea    0x0(%esi),%esi

80102a90 <kbdintr>:

void
kbdintr(void)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a96:	68 b0 29 10 80       	push   $0x801029b0
80102a9b:	e8 e0 dd ff ff       	call   80100880 <consoleintr>
}
80102aa0:	83 c4 10             	add    $0x10,%esp
80102aa3:	c9                   	leave  
80102aa4:	c3                   	ret    
80102aa5:	66 90                	xchg   %ax,%ax
80102aa7:	66 90                	xchg   %ax,%ax
80102aa9:	66 90                	xchg   %ax,%ax
80102aab:	66 90                	xchg   %ax,%ax
80102aad:	66 90                	xchg   %ax,%ax
80102aaf:	90                   	nop

80102ab0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ab0:	a1 20 17 11 80       	mov    0x80111720,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	0f 84 cb 00 00 00    	je     80102b88 <lapicinit+0xd8>
  lapic[index] = value;
80102abd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ac4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ad1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ade:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ae4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102aeb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102aee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102af8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102afb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102afe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b05:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b08:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b0b:	8b 50 30             	mov    0x30(%eax),%edx
80102b0e:	c1 ea 10             	shr    $0x10,%edx
80102b11:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b17:	75 77                	jne    80102b90 <lapicinit+0xe0>
  lapic[index] = value;
80102b19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b23:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b64:	8b 50 20             	mov    0x20(%eax),%edx
80102b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b76:	80 e6 10             	and    $0x10,%dh
80102b79:	75 f5                	jne    80102b70 <lapicinit+0xc0>
  lapic[index] = value;
80102b7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b85:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b88:	c3                   	ret    
80102b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102b90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102b9d:	e9 77 ff ff ff       	jmp    80102b19 <lapicinit+0x69>
80102ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bb0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102bb0:	a1 20 17 11 80       	mov    0x80111720,%eax
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	74 07                	je     80102bc0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102bb9:	8b 40 20             	mov    0x20(%eax),%eax
80102bbc:	c1 e8 18             	shr    $0x18,%eax
80102bbf:	c3                   	ret    
    return 0;
80102bc0:	31 c0                	xor    %eax,%eax
}
80102bc2:	c3                   	ret    
80102bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bd0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102bd0:	a1 20 17 11 80       	mov    0x80111720,%eax
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	74 0d                	je     80102be6 <lapiceoi+0x16>
  lapic[index] = value;
80102bd9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102be0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102be6:	c3                   	ret    
80102be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102bf0:	c3                   	ret    
80102bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop

80102c00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c06:	ba 70 00 00 00       	mov    $0x70,%edx
80102c0b:	89 e5                	mov    %esp,%ebp
80102c0d:	53                   	push   %ebx
80102c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c14:	ee                   	out    %al,(%dx)
80102c15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c20:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c3e:	a1 20 17 11 80       	mov    0x80111720,%eax
80102c43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c8d:	c9                   	leave  
80102c8e:	c3                   	ret    
80102c8f:	90                   	nop

80102c90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102c90:	55                   	push   %ebp
80102c91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c96:	ba 70 00 00 00       	mov    $0x70,%edx
80102c9b:	89 e5                	mov    %esp,%ebp
80102c9d:	57                   	push   %edi
80102c9e:	56                   	push   %esi
80102c9f:	53                   	push   %ebx
80102ca0:	83 ec 4c             	sub    $0x4c,%esp
80102ca3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ca9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102caa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cad:	bb 70 00 00 00       	mov    $0x70,%ebx
80102cb2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102cb5:	8d 76 00             	lea    0x0(%esi),%esi
80102cb8:	31 c0                	xor    %eax,%eax
80102cba:	89 da                	mov    %ebx,%edx
80102cbc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102cc2:	89 ca                	mov    %ecx,%edx
80102cc4:	ec                   	in     (%dx),%al
80102cc5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc8:	89 da                	mov    %ebx,%edx
80102cca:	b8 02 00 00 00       	mov    $0x2,%eax
80102ccf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd0:	89 ca                	mov    %ecx,%edx
80102cd2:	ec                   	in     (%dx),%al
80102cd3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd6:	89 da                	mov    %ebx,%edx
80102cd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cde:	89 ca                	mov    %ecx,%edx
80102ce0:	ec                   	in     (%dx),%al
80102ce1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce4:	89 da                	mov    %ebx,%edx
80102ce6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ceb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cec:	89 ca                	mov    %ecx,%edx
80102cee:	ec                   	in     (%dx),%al
80102cef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf2:	89 da                	mov    %ebx,%edx
80102cf4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cf9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfa:	89 ca                	mov    %ecx,%edx
80102cfc:	ec                   	in     (%dx),%al
80102cfd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cff:	89 da                	mov    %ebx,%edx
80102d01:	b8 09 00 00 00       	mov    $0x9,%eax
80102d06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d07:	89 ca                	mov    %ecx,%edx
80102d09:	ec                   	in     (%dx),%al
80102d0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d0c:	89 da                	mov    %ebx,%edx
80102d0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d14:	89 ca                	mov    %ecx,%edx
80102d16:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d17:	84 c0                	test   %al,%al
80102d19:	78 9d                	js     80102cb8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d1f:	89 fa                	mov    %edi,%edx
80102d21:	0f b6 fa             	movzbl %dl,%edi
80102d24:	89 f2                	mov    %esi,%edx
80102d26:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d29:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d2d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d30:	89 da                	mov    %ebx,%edx
80102d32:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d35:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d38:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d3c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d49:	31 c0                	xor    %eax,%eax
80102d4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4c:	89 ca                	mov    %ecx,%edx
80102d4e:	ec                   	in     (%dx),%al
80102d4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d52:	89 da                	mov    %ebx,%edx
80102d54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d57:	b8 02 00 00 00       	mov    $0x2,%eax
80102d5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5d:	89 ca                	mov    %ecx,%edx
80102d5f:	ec                   	in     (%dx),%al
80102d60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d63:	89 da                	mov    %ebx,%edx
80102d65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d68:	b8 04 00 00 00       	mov    $0x4,%eax
80102d6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6e:	89 ca                	mov    %ecx,%edx
80102d70:	ec                   	in     (%dx),%al
80102d71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d74:	89 da                	mov    %ebx,%edx
80102d76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d79:	b8 07 00 00 00       	mov    $0x7,%eax
80102d7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7f:	89 ca                	mov    %ecx,%edx
80102d81:	ec                   	in     (%dx),%al
80102d82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d85:	89 da                	mov    %ebx,%edx
80102d87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d90:	89 ca                	mov    %ecx,%edx
80102d92:	ec                   	in     (%dx),%al
80102d93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d96:	89 da                	mov    %ebx,%edx
80102d98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102da0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da1:	89 ca                	mov    %ecx,%edx
80102da3:	ec                   	in     (%dx),%al
80102da4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102da7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102daa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102db0:	6a 18                	push   $0x18
80102db2:	50                   	push   %eax
80102db3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102db6:	50                   	push   %eax
80102db7:	e8 b4 1b 00 00       	call   80104970 <memcmp>
80102dbc:	83 c4 10             	add    $0x10,%esp
80102dbf:	85 c0                	test   %eax,%eax
80102dc1:	0f 85 f1 fe ff ff    	jne    80102cb8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102dc7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dcb:	75 78                	jne    80102e45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dd0:	89 c2                	mov    %eax,%edx
80102dd2:	83 e0 0f             	and    $0xf,%eax
80102dd5:	c1 ea 04             	shr    $0x4,%edx
80102dd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ddb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dde:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102de1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102de4:	89 c2                	mov    %eax,%edx
80102de6:	83 e0 0f             	and    $0xf,%eax
80102de9:	c1 ea 04             	shr    $0x4,%edx
80102dec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102def:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102df2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102df5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102df8:	89 c2                	mov    %eax,%edx
80102dfa:	83 e0 0f             	and    $0xf,%eax
80102dfd:	c1 ea 04             	shr    $0x4,%edx
80102e00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e0c:	89 c2                	mov    %eax,%edx
80102e0e:	83 e0 0f             	and    $0xf,%eax
80102e11:	c1 ea 04             	shr    $0x4,%edx
80102e14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e20:	89 c2                	mov    %eax,%edx
80102e22:	83 e0 0f             	and    $0xf,%eax
80102e25:	c1 ea 04             	shr    $0x4,%edx
80102e28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e34:	89 c2                	mov    %eax,%edx
80102e36:	83 e0 0f             	and    $0xf,%eax
80102e39:	c1 ea 04             	shr    $0x4,%edx
80102e3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e45:	8b 75 08             	mov    0x8(%ebp),%esi
80102e48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e4b:	89 06                	mov    %eax,(%esi)
80102e4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e50:	89 46 04             	mov    %eax,0x4(%esi)
80102e53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e56:	89 46 08             	mov    %eax,0x8(%esi)
80102e59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e62:	89 46 10             	mov    %eax,0x10(%esi)
80102e65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e75:	5b                   	pop    %ebx
80102e76:	5e                   	pop    %esi
80102e77:	5f                   	pop    %edi
80102e78:	5d                   	pop    %ebp
80102e79:	c3                   	ret    
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e80:	8b 0d 88 17 11 80    	mov    0x80111788,%ecx
80102e86:	85 c9                	test   %ecx,%ecx
80102e88:	0f 8e 8a 00 00 00    	jle    80102f18 <install_trans+0x98>
{
80102e8e:	55                   	push   %ebp
80102e8f:	89 e5                	mov    %esp,%ebp
80102e91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102e92:	31 ff                	xor    %edi,%edi
{
80102e94:	56                   	push   %esi
80102e95:	53                   	push   %ebx
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ea0:	a1 74 17 11 80       	mov    0x80111774,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 f8                	add    %edi,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 84 17 11 80    	push   0x80111784
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 bd 8c 17 11 80 	push   -0x7feee874(,%edi,4)
80102ec4:	ff 35 84 17 11 80    	push   0x80111784
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ed5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ed7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 d7 1a 00 00       	call   801049c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ee9:	89 1c 24             	mov    %ebx,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ef1:	89 34 24             	mov    %esi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ef9:	89 1c 24             	mov    %ebx,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	39 3d 88 17 11 80    	cmp    %edi,0x80111788
80102f0a:	7f 94                	jg     80102ea0 <install_trans+0x20>
  }
}
80102f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f0f:	5b                   	pop    %ebx
80102f10:	5e                   	pop    %esi
80102f11:	5f                   	pop    %edi
80102f12:	5d                   	pop    %ebp
80102f13:	c3                   	ret    
80102f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f18:	c3                   	ret    
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f27:	ff 35 74 17 11 80    	push   0x80111774
80102f2d:	ff 35 84 17 11 80    	push   0x80111784
80102f33:	e8 98 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f3d:	a1 88 17 11 80       	mov    0x80111788,%eax
80102f42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102f45:	85 c0                	test   %eax,%eax
80102f47:	7e 19                	jle    80102f62 <write_head+0x42>
80102f49:	31 d2                	xor    %edx,%edx
80102f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102f50:	8b 0c 95 8c 17 11 80 	mov    -0x7feee874(,%edx,4),%ecx
80102f57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f5b:	83 c2 01             	add    $0x1,%edx
80102f5e:	39 d0                	cmp    %edx,%eax
80102f60:	75 ee                	jne    80102f50 <write_head+0x30>
  }
  bwrite(buf);
80102f62:	83 ec 0c             	sub    $0xc,%esp
80102f65:	53                   	push   %ebx
80102f66:	e8 45 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102f6b:	89 1c 24             	mov    %ebx,(%esp)
80102f6e:	e8 7d d2 ff ff       	call   801001f0 <brelse>
}
80102f73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f76:	83 c4 10             	add    $0x10,%esp
80102f79:	c9                   	leave  
80102f7a:	c3                   	ret    
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop

80102f80 <initlog>:
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	53                   	push   %ebx
80102f84:	83 ec 2c             	sub    $0x2c,%esp
80102f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f8a:	68 40 79 10 80       	push   $0x80107940
80102f8f:	68 40 17 11 80       	push   $0x80111740
80102f94:	e8 f7 16 00 00       	call   80104690 <initlock>
  readsb(dev, &sb);
80102f99:	58                   	pop    %eax
80102f9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f9d:	5a                   	pop    %edx
80102f9e:	50                   	push   %eax
80102f9f:	53                   	push   %ebx
80102fa0:	e8 3b e8 ff ff       	call   801017e0 <readsb>
  log.start = sb.logstart;
80102fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102fa8:	59                   	pop    %ecx
  log.dev = dev;
80102fa9:	89 1d 84 17 11 80    	mov    %ebx,0x80111784
  log.size = sb.nlog;
80102faf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102fb2:	a3 74 17 11 80       	mov    %eax,0x80111774
  log.size = sb.nlog;
80102fb7:	89 15 78 17 11 80    	mov    %edx,0x80111778
  struct buf *buf = bread(log.dev, log.start);
80102fbd:	5a                   	pop    %edx
80102fbe:	50                   	push   %eax
80102fbf:	53                   	push   %ebx
80102fc0:	e8 0b d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102fc5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102fc8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102fcb:	89 1d 88 17 11 80    	mov    %ebx,0x80111788
  for (i = 0; i < log.lh.n; i++) {
80102fd1:	85 db                	test   %ebx,%ebx
80102fd3:	7e 1d                	jle    80102ff2 <initlog+0x72>
80102fd5:	31 d2                	xor    %edx,%edx
80102fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fde:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102fe0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102fe4:	89 0c 95 8c 17 11 80 	mov    %ecx,-0x7feee874(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102feb:	83 c2 01             	add    $0x1,%edx
80102fee:	39 d3                	cmp    %edx,%ebx
80102ff0:	75 ee                	jne    80102fe0 <initlog+0x60>
  brelse(buf);
80102ff2:	83 ec 0c             	sub    $0xc,%esp
80102ff5:	50                   	push   %eax
80102ff6:	e8 f5 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ffb:	e8 80 fe ff ff       	call   80102e80 <install_trans>
  log.lh.n = 0;
80103000:	c7 05 88 17 11 80 00 	movl   $0x0,0x80111788
80103007:	00 00 00 
  write_head(); // clear the log
8010300a:	e8 11 ff ff ff       	call   80102f20 <write_head>
}
8010300f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103012:	83 c4 10             	add    $0x10,%esp
80103015:	c9                   	leave  
80103016:	c3                   	ret    
80103017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301e:	66 90                	xchg   %ax,%ax

80103020 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103026:	68 40 17 11 80       	push   $0x80111740
8010302b:	e8 30 18 00 00       	call   80104860 <acquire>
80103030:	83 c4 10             	add    $0x10,%esp
80103033:	eb 18                	jmp    8010304d <begin_op+0x2d>
80103035:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103038:	83 ec 08             	sub    $0x8,%esp
8010303b:	68 40 17 11 80       	push   $0x80111740
80103040:	68 40 17 11 80       	push   $0x80111740
80103045:	e8 b6 12 00 00       	call   80104300 <sleep>
8010304a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010304d:	a1 80 17 11 80       	mov    0x80111780,%eax
80103052:	85 c0                	test   %eax,%eax
80103054:	75 e2                	jne    80103038 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103056:	a1 7c 17 11 80       	mov    0x8011177c,%eax
8010305b:	8b 15 88 17 11 80    	mov    0x80111788,%edx
80103061:	83 c0 01             	add    $0x1,%eax
80103064:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103067:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010306a:	83 fa 1e             	cmp    $0x1e,%edx
8010306d:	7f c9                	jg     80103038 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010306f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103072:	a3 7c 17 11 80       	mov    %eax,0x8011177c
      release(&log.lock);
80103077:	68 40 17 11 80       	push   $0x80111740
8010307c:	e8 7f 17 00 00       	call   80104800 <release>
      break;
    }
  }
}
80103081:	83 c4 10             	add    $0x10,%esp
80103084:	c9                   	leave  
80103085:	c3                   	ret    
80103086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010308d:	8d 76 00             	lea    0x0(%esi),%esi

80103090 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	57                   	push   %edi
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103099:	68 40 17 11 80       	push   $0x80111740
8010309e:	e8 bd 17 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
801030a3:	a1 7c 17 11 80       	mov    0x8011177c,%eax
  if(log.committing)
801030a8:	8b 35 80 17 11 80    	mov    0x80111780,%esi
801030ae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801030b4:	89 1d 7c 17 11 80    	mov    %ebx,0x8011177c
  if(log.committing)
801030ba:	85 f6                	test   %esi,%esi
801030bc:	0f 85 22 01 00 00    	jne    801031e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801030c2:	85 db                	test   %ebx,%ebx
801030c4:	0f 85 f6 00 00 00    	jne    801031c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801030ca:	c7 05 80 17 11 80 01 	movl   $0x1,0x80111780
801030d1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 40 17 11 80       	push   $0x80111740
801030dc:	e8 1f 17 00 00       	call   80104800 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030e1:	8b 0d 88 17 11 80    	mov    0x80111788,%ecx
801030e7:	83 c4 10             	add    $0x10,%esp
801030ea:	85 c9                	test   %ecx,%ecx
801030ec:	7f 42                	jg     80103130 <end_op+0xa0>
    acquire(&log.lock);
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 40 17 11 80       	push   $0x80111740
801030f6:	e8 65 17 00 00       	call   80104860 <acquire>
    wakeup(&log);
801030fb:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
    log.committing = 0;
80103102:	c7 05 80 17 11 80 00 	movl   $0x0,0x80111780
80103109:	00 00 00 
    wakeup(&log);
8010310c:	e8 af 12 00 00       	call   801043c0 <wakeup>
    release(&log.lock);
80103111:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
80103118:	e8 e3 16 00 00       	call   80104800 <release>
8010311d:	83 c4 10             	add    $0x10,%esp
}
80103120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103123:	5b                   	pop    %ebx
80103124:	5e                   	pop    %esi
80103125:	5f                   	pop    %edi
80103126:	5d                   	pop    %ebp
80103127:	c3                   	ret    
80103128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103130:	a1 74 17 11 80       	mov    0x80111774,%eax
80103135:	83 ec 08             	sub    $0x8,%esp
80103138:	01 d8                	add    %ebx,%eax
8010313a:	83 c0 01             	add    $0x1,%eax
8010313d:	50                   	push   %eax
8010313e:	ff 35 84 17 11 80    	push   0x80111784
80103144:	e8 87 cf ff ff       	call   801000d0 <bread>
80103149:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010314b:	58                   	pop    %eax
8010314c:	5a                   	pop    %edx
8010314d:	ff 34 9d 8c 17 11 80 	push   -0x7feee874(,%ebx,4)
80103154:	ff 35 84 17 11 80    	push   0x80111784
  for (tail = 0; tail < log.lh.n; tail++) {
8010315a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010315d:	e8 6e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103162:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103165:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103167:	8d 40 5c             	lea    0x5c(%eax),%eax
8010316a:	68 00 02 00 00       	push   $0x200
8010316f:	50                   	push   %eax
80103170:	8d 46 5c             	lea    0x5c(%esi),%eax
80103173:	50                   	push   %eax
80103174:	e8 47 18 00 00       	call   801049c0 <memmove>
    bwrite(to);  // write the log
80103179:	89 34 24             	mov    %esi,(%esp)
8010317c:	e8 2f d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103181:	89 3c 24             	mov    %edi,(%esp)
80103184:	e8 67 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103189:	89 34 24             	mov    %esi,(%esp)
8010318c:	e8 5f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103191:	83 c4 10             	add    $0x10,%esp
80103194:	3b 1d 88 17 11 80    	cmp    0x80111788,%ebx
8010319a:	7c 94                	jl     80103130 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010319c:	e8 7f fd ff ff       	call   80102f20 <write_head>
    install_trans(); // Now install writes to home locations
801031a1:	e8 da fc ff ff       	call   80102e80 <install_trans>
    log.lh.n = 0;
801031a6:	c7 05 88 17 11 80 00 	movl   $0x0,0x80111788
801031ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801031b0:	e8 6b fd ff ff       	call   80102f20 <write_head>
801031b5:	e9 34 ff ff ff       	jmp    801030ee <end_op+0x5e>
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801031c0:	83 ec 0c             	sub    $0xc,%esp
801031c3:	68 40 17 11 80       	push   $0x80111740
801031c8:	e8 f3 11 00 00       	call   801043c0 <wakeup>
  release(&log.lock);
801031cd:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
801031d4:	e8 27 16 00 00       	call   80104800 <release>
801031d9:	83 c4 10             	add    $0x10,%esp
}
801031dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031df:	5b                   	pop    %ebx
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
    panic("log.committing");
801031e4:	83 ec 0c             	sub    $0xc,%esp
801031e7:	68 44 79 10 80       	push   $0x80107944
801031ec:	e8 8f d1 ff ff       	call   80100380 <panic>
801031f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103207:	8b 15 88 17 11 80    	mov    0x80111788,%edx
{
8010320d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103210:	83 fa 1d             	cmp    $0x1d,%edx
80103213:	0f 8f 85 00 00 00    	jg     8010329e <log_write+0x9e>
80103219:	a1 78 17 11 80       	mov    0x80111778,%eax
8010321e:	83 e8 01             	sub    $0x1,%eax
80103221:	39 c2                	cmp    %eax,%edx
80103223:	7d 79                	jge    8010329e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103225:	a1 7c 17 11 80       	mov    0x8011177c,%eax
8010322a:	85 c0                	test   %eax,%eax
8010322c:	7e 7d                	jle    801032ab <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010322e:	83 ec 0c             	sub    $0xc,%esp
80103231:	68 40 17 11 80       	push   $0x80111740
80103236:	e8 25 16 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010323b:	8b 15 88 17 11 80    	mov    0x80111788,%edx
80103241:	83 c4 10             	add    $0x10,%esp
80103244:	85 d2                	test   %edx,%edx
80103246:	7e 4a                	jle    80103292 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103248:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010324b:	31 c0                	xor    %eax,%eax
8010324d:	eb 08                	jmp    80103257 <log_write+0x57>
8010324f:	90                   	nop
80103250:	83 c0 01             	add    $0x1,%eax
80103253:	39 c2                	cmp    %eax,%edx
80103255:	74 29                	je     80103280 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103257:	39 0c 85 8c 17 11 80 	cmp    %ecx,-0x7feee874(,%eax,4)
8010325e:	75 f0                	jne    80103250 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103260:	89 0c 85 8c 17 11 80 	mov    %ecx,-0x7feee874(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103267:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010326a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010326d:	c7 45 08 40 17 11 80 	movl   $0x80111740,0x8(%ebp)
}
80103274:	c9                   	leave  
  release(&log.lock);
80103275:	e9 86 15 00 00       	jmp    80104800 <release>
8010327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103280:	89 0c 95 8c 17 11 80 	mov    %ecx,-0x7feee874(,%edx,4)
    log.lh.n++;
80103287:	83 c2 01             	add    $0x1,%edx
8010328a:	89 15 88 17 11 80    	mov    %edx,0x80111788
80103290:	eb d5                	jmp    80103267 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103292:	8b 43 08             	mov    0x8(%ebx),%eax
80103295:	a3 8c 17 11 80       	mov    %eax,0x8011178c
  if (i == log.lh.n)
8010329a:	75 cb                	jne    80103267 <log_write+0x67>
8010329c:	eb e9                	jmp    80103287 <log_write+0x87>
    panic("too big a transaction");
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	68 53 79 10 80       	push   $0x80107953
801032a6:	e8 d5 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801032ab:	83 ec 0c             	sub    $0xc,%esp
801032ae:	68 69 79 10 80       	push   $0x80107969
801032b3:	e8 c8 d0 ff ff       	call   80100380 <panic>
801032b8:	66 90                	xchg   %ax,%ax
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	53                   	push   %ebx
801032c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032c7:	e8 44 09 00 00       	call   80103c10 <cpuid>
801032cc:	89 c3                	mov    %eax,%ebx
801032ce:	e8 3d 09 00 00       	call   80103c10 <cpuid>
801032d3:	83 ec 04             	sub    $0x4,%esp
801032d6:	53                   	push   %ebx
801032d7:	50                   	push   %eax
801032d8:	68 84 79 10 80       	push   $0x80107984
801032dd:	e8 be d3 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801032e2:	e8 b9 28 00 00       	call   80105ba0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032e7:	e8 c4 08 00 00       	call   80103bb0 <mycpu>
801032ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032ee:	b8 01 00 00 00       	mov    $0x1,%eax
801032f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801032fa:	e8 f1 0b 00 00       	call   80103ef0 <scheduler>
801032ff:	90                   	nop

80103300 <mpenter>:
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103306:	e8 85 39 00 00       	call   80106c90 <switchkvm>
  seginit();
8010330b:	e8 f0 38 00 00       	call   80106c00 <seginit>
  lapicinit();
80103310:	e8 9b f7 ff ff       	call   80102ab0 <lapicinit>
  mpmain();
80103315:	e8 a6 ff ff ff       	call   801032c0 <mpmain>
8010331a:	66 90                	xchg   %ax,%ax
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <main>:
{
80103320:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103324:	83 e4 f0             	and    $0xfffffff0,%esp
80103327:	ff 71 fc             	push   -0x4(%ecx)
8010332a:	55                   	push   %ebp
8010332b:	89 e5                	mov    %esp,%ebp
8010332d:	53                   	push   %ebx
8010332e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010332f:	83 ec 08             	sub    $0x8,%esp
80103332:	68 00 00 40 80       	push   $0x80400000
80103337:	68 70 55 11 80       	push   $0x80115570
8010333c:	e8 8f f5 ff ff       	call   801028d0 <kinit1>
  kvmalloc();      // kernel page table
80103341:	e8 3a 3e 00 00       	call   80107180 <kvmalloc>
  mpinit();        // detect other processors
80103346:	e8 85 01 00 00       	call   801034d0 <mpinit>
  lapicinit();     // interrupt controller
8010334b:	e8 60 f7 ff ff       	call   80102ab0 <lapicinit>
  seginit();       // segment descriptors
80103350:	e8 ab 38 00 00       	call   80106c00 <seginit>
  picinit();       // disable pic
80103355:	e8 76 03 00 00       	call   801036d0 <picinit>
  ioapicinit();    // another interrupt controller
8010335a:	e8 31 f3 ff ff       	call   80102690 <ioapicinit>
  consoleinit();   // console hardware
8010335f:	e8 bc d9 ff ff       	call   80100d20 <consoleinit>
  uartinit();      // serial port
80103364:	e8 27 2b 00 00       	call   80105e90 <uartinit>
  pinit();         // process table
80103369:	e8 22 08 00 00       	call   80103b90 <pinit>
  tvinit();        // trap vectors
8010336e:	e8 ad 27 00 00       	call   80105b20 <tvinit>
  binit();         // buffer cache
80103373:	e8 c8 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103378:	e8 53 dd ff ff       	call   801010d0 <fileinit>
  ideinit();       // disk 
8010337d:	e8 fe f0 ff ff       	call   80102480 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103382:	83 c4 0c             	add    $0xc,%esp
80103385:	68 8a 00 00 00       	push   $0x8a
8010338a:	68 8c a4 10 80       	push   $0x8010a48c
8010338f:	68 00 70 00 80       	push   $0x80007000
80103394:	e8 27 16 00 00       	call   801049c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	69 05 24 18 11 80 b0 	imul   $0xb0,0x80111824,%eax
801033a3:	00 00 00 
801033a6:	05 40 18 11 80       	add    $0x80111840,%eax
801033ab:	3d 40 18 11 80       	cmp    $0x80111840,%eax
801033b0:	76 7e                	jbe    80103430 <main+0x110>
801033b2:	bb 40 18 11 80       	mov    $0x80111840,%ebx
801033b7:	eb 20                	jmp    801033d9 <main+0xb9>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033c0:	69 05 24 18 11 80 b0 	imul   $0xb0,0x80111824,%eax
801033c7:	00 00 00 
801033ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033d0:	05 40 18 11 80       	add    $0x80111840,%eax
801033d5:	39 c3                	cmp    %eax,%ebx
801033d7:	73 57                	jae    80103430 <main+0x110>
    if(c == mycpu())  // We've started already.
801033d9:	e8 d2 07 00 00       	call   80103bb0 <mycpu>
801033de:	39 c3                	cmp    %eax,%ebx
801033e0:	74 de                	je     801033c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801033e2:	e8 59 f5 ff ff       	call   80102940 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801033e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801033ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103300,0x80006ff8
801033f1:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801033f4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801033fb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033fe:	05 00 10 00 00       	add    $0x1000,%eax
80103403:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103408:	0f b6 03             	movzbl (%ebx),%eax
8010340b:	68 00 70 00 00       	push   $0x7000
80103410:	50                   	push   %eax
80103411:	e8 ea f7 ff ff       	call   80102c00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103416:	83 c4 10             	add    $0x10,%esp
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103420:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103426:	85 c0                	test   %eax,%eax
80103428:	74 f6                	je     80103420 <main+0x100>
8010342a:	eb 94                	jmp    801033c0 <main+0xa0>
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103430:	83 ec 08             	sub    $0x8,%esp
80103433:	68 00 00 00 8e       	push   $0x8e000000
80103438:	68 00 00 40 80       	push   $0x80400000
8010343d:	e8 2e f4 ff ff       	call   80102870 <kinit2>
  userinit();      // first user process
80103442:	e8 19 08 00 00       	call   80103c60 <userinit>
  mpmain();        // finish this processor's setup
80103447:	e8 74 fe ff ff       	call   801032c0 <mpmain>
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103455:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010345b:	53                   	push   %ebx
  e = addr+len;
8010345c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010345f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103462:	39 de                	cmp    %ebx,%esi
80103464:	72 10                	jb     80103476 <mpsearch1+0x26>
80103466:	eb 50                	jmp    801034b8 <mpsearch1+0x68>
80103468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346f:	90                   	nop
80103470:	89 fe                	mov    %edi,%esi
80103472:	39 fb                	cmp    %edi,%ebx
80103474:	76 42                	jbe    801034b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103476:	83 ec 04             	sub    $0x4,%esp
80103479:	8d 7e 10             	lea    0x10(%esi),%edi
8010347c:	6a 04                	push   $0x4
8010347e:	68 98 79 10 80       	push   $0x80107998
80103483:	56                   	push   %esi
80103484:	e8 e7 14 00 00       	call   80104970 <memcmp>
80103489:	83 c4 10             	add    $0x10,%esp
8010348c:	85 c0                	test   %eax,%eax
8010348e:	75 e0                	jne    80103470 <mpsearch1+0x20>
80103490:	89 f2                	mov    %esi,%edx
80103492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103498:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010349b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010349e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034a0:	39 fa                	cmp    %edi,%edx
801034a2:	75 f4                	jne    80103498 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034a4:	84 c0                	test   %al,%al
801034a6:	75 c8                	jne    80103470 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ab:	89 f0                	mov    %esi,%eax
801034ad:	5b                   	pop    %ebx
801034ae:	5e                   	pop    %esi
801034af:	5f                   	pop    %edi
801034b0:	5d                   	pop    %ebp
801034b1:	c3                   	ret    
801034b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034bb:	31 f6                	xor    %esi,%esi
}
801034bd:	5b                   	pop    %ebx
801034be:	89 f0                	mov    %esi,%eax
801034c0:	5e                   	pop    %esi
801034c1:	5f                   	pop    %edi
801034c2:	5d                   	pop    %ebp
801034c3:	c3                   	ret    
801034c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop

801034d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
801034d5:	53                   	push   %ebx
801034d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801034d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034e7:	c1 e0 08             	shl    $0x8,%eax
801034ea:	09 d0                	or     %edx,%eax
801034ec:	c1 e0 04             	shl    $0x4,%eax
801034ef:	75 1b                	jne    8010350c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034ff:	c1 e0 08             	shl    $0x8,%eax
80103502:	09 d0                	or     %edx,%eax
80103504:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103507:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010350c:	ba 00 04 00 00       	mov    $0x400,%edx
80103511:	e8 3a ff ff ff       	call   80103450 <mpsearch1>
80103516:	89 c3                	mov    %eax,%ebx
80103518:	85 c0                	test   %eax,%eax
8010351a:	0f 84 40 01 00 00    	je     80103660 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103520:	8b 73 04             	mov    0x4(%ebx),%esi
80103523:	85 f6                	test   %esi,%esi
80103525:	0f 84 25 01 00 00    	je     80103650 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010352b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010352e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103534:	6a 04                	push   $0x4
80103536:	68 9d 79 10 80       	push   $0x8010799d
8010353b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010353c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010353f:	e8 2c 14 00 00       	call   80104970 <memcmp>
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 c0                	test   %eax,%eax
80103549:	0f 85 01 01 00 00    	jne    80103650 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010354f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103556:	3c 01                	cmp    $0x1,%al
80103558:	74 08                	je     80103562 <mpinit+0x92>
8010355a:	3c 04                	cmp    $0x4,%al
8010355c:	0f 85 ee 00 00 00    	jne    80103650 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103562:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103569:	66 85 d2             	test   %dx,%dx
8010356c:	74 22                	je     80103590 <mpinit+0xc0>
8010356e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103571:	89 f0                	mov    %esi,%eax
  sum = 0;
80103573:	31 d2                	xor    %edx,%edx
80103575:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103578:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010357f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103582:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103584:	39 c7                	cmp    %eax,%edi
80103586:	75 f0                	jne    80103578 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103588:	84 d2                	test   %dl,%dl
8010358a:	0f 85 c0 00 00 00    	jne    80103650 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103590:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103596:	a3 20 17 11 80       	mov    %eax,0x80111720
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010359b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801035a2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801035a8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ad:	03 55 e4             	add    -0x1c(%ebp),%edx
801035b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801035b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b7:	90                   	nop
801035b8:	39 d0                	cmp    %edx,%eax
801035ba:	73 15                	jae    801035d1 <mpinit+0x101>
    switch(*p){
801035bc:	0f b6 08             	movzbl (%eax),%ecx
801035bf:	80 f9 02             	cmp    $0x2,%cl
801035c2:	74 4c                	je     80103610 <mpinit+0x140>
801035c4:	77 3a                	ja     80103600 <mpinit+0x130>
801035c6:	84 c9                	test   %cl,%cl
801035c8:	74 56                	je     80103620 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035ca:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035cd:	39 d0                	cmp    %edx,%eax
801035cf:	72 eb                	jb     801035bc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801035d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035d4:	85 f6                	test   %esi,%esi
801035d6:	0f 84 d9 00 00 00    	je     801036b5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801035dc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801035e0:	74 15                	je     801035f7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035e2:	b8 70 00 00 00       	mov    $0x70,%eax
801035e7:	ba 22 00 00 00       	mov    $0x22,%edx
801035ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035ed:	ba 23 00 00 00       	mov    $0x23,%edx
801035f2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035f3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035f6:	ee                   	out    %al,(%dx)
  }
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	5b                   	pop    %ebx
801035fb:	5e                   	pop    %esi
801035fc:	5f                   	pop    %edi
801035fd:	5d                   	pop    %ebp
801035fe:	c3                   	ret    
801035ff:	90                   	nop
    switch(*p){
80103600:	83 e9 03             	sub    $0x3,%ecx
80103603:	80 f9 01             	cmp    $0x1,%cl
80103606:	76 c2                	jbe    801035ca <mpinit+0xfa>
80103608:	31 f6                	xor    %esi,%esi
8010360a:	eb ac                	jmp    801035b8 <mpinit+0xe8>
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103610:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103614:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103617:	88 0d 20 18 11 80    	mov    %cl,0x80111820
      continue;
8010361d:	eb 99                	jmp    801035b8 <mpinit+0xe8>
8010361f:	90                   	nop
      if(ncpu < NCPU) {
80103620:	8b 0d 24 18 11 80    	mov    0x80111824,%ecx
80103626:	83 f9 07             	cmp    $0x7,%ecx
80103629:	7f 19                	jg     80103644 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010362b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103631:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103635:	83 c1 01             	add    $0x1,%ecx
80103638:	89 0d 24 18 11 80    	mov    %ecx,0x80111824
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010363e:	88 9f 40 18 11 80    	mov    %bl,-0x7feee7c0(%edi)
      p += sizeof(struct mpproc);
80103644:	83 c0 14             	add    $0x14,%eax
      continue;
80103647:	e9 6c ff ff ff       	jmp    801035b8 <mpinit+0xe8>
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 a2 79 10 80       	push   $0x801079a2
80103658:	e8 23 cd ff ff       	call   80100380 <panic>
8010365d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103660:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103665:	eb 13                	jmp    8010367a <mpinit+0x1aa>
80103667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010366e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103670:	89 f3                	mov    %esi,%ebx
80103672:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103678:	74 d6                	je     80103650 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010367a:	83 ec 04             	sub    $0x4,%esp
8010367d:	8d 73 10             	lea    0x10(%ebx),%esi
80103680:	6a 04                	push   $0x4
80103682:	68 98 79 10 80       	push   $0x80107998
80103687:	53                   	push   %ebx
80103688:	e8 e3 12 00 00       	call   80104970 <memcmp>
8010368d:	83 c4 10             	add    $0x10,%esp
80103690:	85 c0                	test   %eax,%eax
80103692:	75 dc                	jne    80103670 <mpinit+0x1a0>
80103694:	89 da                	mov    %ebx,%edx
80103696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801036a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801036a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801036a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036a8:	39 d6                	cmp    %edx,%esi
801036aa:	75 f4                	jne    801036a0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036ac:	84 c0                	test   %al,%al
801036ae:	75 c0                	jne    80103670 <mpinit+0x1a0>
801036b0:	e9 6b fe ff ff       	jmp    80103520 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801036b5:	83 ec 0c             	sub    $0xc,%esp
801036b8:	68 bc 79 10 80       	push   $0x801079bc
801036bd:	e8 be cc ff ff       	call   80100380 <panic>
801036c2:	66 90                	xchg   %ax,%ax
801036c4:	66 90                	xchg   %ax,%ax
801036c6:	66 90                	xchg   %ax,%ax
801036c8:	66 90                	xchg   %ax,%ax
801036ca:	66 90                	xchg   %ax,%ax
801036cc:	66 90                	xchg   %ax,%ax
801036ce:	66 90                	xchg   %ax,%ax

801036d0 <picinit>:
801036d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036d5:	ba 21 00 00 00       	mov    $0x21,%edx
801036da:	ee                   	out    %al,(%dx)
801036db:	ba a1 00 00 00       	mov    $0xa1,%edx
801036e0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801036e1:	c3                   	ret    
801036e2:	66 90                	xchg   %ax,%ax
801036e4:	66 90                	xchg   %ax,%ax
801036e6:	66 90                	xchg   %ax,%ax
801036e8:	66 90                	xchg   %ax,%ax
801036ea:	66 90                	xchg   %ax,%ax
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801036ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103705:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010370b:	e8 e0 d9 ff ff       	call   801010f0 <filealloc>
80103710:	89 03                	mov    %eax,(%ebx)
80103712:	85 c0                	test   %eax,%eax
80103714:	0f 84 a8 00 00 00    	je     801037c2 <pipealloc+0xd2>
8010371a:	e8 d1 d9 ff ff       	call   801010f0 <filealloc>
8010371f:	89 06                	mov    %eax,(%esi)
80103721:	85 c0                	test   %eax,%eax
80103723:	0f 84 87 00 00 00    	je     801037b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103729:	e8 12 f2 ff ff       	call   80102940 <kalloc>
8010372e:	89 c7                	mov    %eax,%edi
80103730:	85 c0                	test   %eax,%eax
80103732:	0f 84 b0 00 00 00    	je     801037e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103738:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010373f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103742:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103745:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010374c:	00 00 00 
  p->nwrite = 0;
8010374f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103756:	00 00 00 
  p->nread = 0;
80103759:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103760:	00 00 00 
  initlock(&p->lock, "pipe");
80103763:	68 db 79 10 80       	push   $0x801079db
80103768:	50                   	push   %eax
80103769:	e8 22 0f 00 00       	call   80104690 <initlock>
  (*f0)->type = FD_PIPE;
8010376e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103770:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103773:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103779:	8b 03                	mov    (%ebx),%eax
8010377b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010377f:	8b 03                	mov    (%ebx),%eax
80103781:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103785:	8b 03                	mov    (%ebx),%eax
80103787:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010378a:	8b 06                	mov    (%esi),%eax
8010378c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103792:	8b 06                	mov    (%esi),%eax
80103794:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103798:	8b 06                	mov    (%esi),%eax
8010379a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010379e:	8b 06                	mov    (%esi),%eax
801037a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801037a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037a6:	31 c0                	xor    %eax,%eax
}
801037a8:	5b                   	pop    %ebx
801037a9:	5e                   	pop    %esi
801037aa:	5f                   	pop    %edi
801037ab:	5d                   	pop    %ebp
801037ac:	c3                   	ret    
801037ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801037b0:	8b 03                	mov    (%ebx),%eax
801037b2:	85 c0                	test   %eax,%eax
801037b4:	74 1e                	je     801037d4 <pipealloc+0xe4>
    fileclose(*f0);
801037b6:	83 ec 0c             	sub    $0xc,%esp
801037b9:	50                   	push   %eax
801037ba:	e8 f1 d9 ff ff       	call   801011b0 <fileclose>
801037bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037c2:	8b 06                	mov    (%esi),%eax
801037c4:	85 c0                	test   %eax,%eax
801037c6:	74 0c                	je     801037d4 <pipealloc+0xe4>
    fileclose(*f1);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	50                   	push   %eax
801037cc:	e8 df d9 ff ff       	call   801011b0 <fileclose>
801037d1:	83 c4 10             	add    $0x10,%esp
}
801037d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037dc:	5b                   	pop    %ebx
801037dd:	5e                   	pop    %esi
801037de:	5f                   	pop    %edi
801037df:	5d                   	pop    %ebp
801037e0:	c3                   	ret    
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801037e8:	8b 03                	mov    (%ebx),%eax
801037ea:	85 c0                	test   %eax,%eax
801037ec:	75 c8                	jne    801037b6 <pipealloc+0xc6>
801037ee:	eb d2                	jmp    801037c2 <pipealloc+0xd2>

801037f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801037fb:	83 ec 0c             	sub    $0xc,%esp
801037fe:	53                   	push   %ebx
801037ff:	e8 5c 10 00 00       	call   80104860 <acquire>
  if(writable){
80103804:	83 c4 10             	add    $0x10,%esp
80103807:	85 f6                	test   %esi,%esi
80103809:	74 65                	je     80103870 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103814:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010381b:	00 00 00 
    wakeup(&p->nread);
8010381e:	50                   	push   %eax
8010381f:	e8 9c 0b 00 00       	call   801043c0 <wakeup>
80103824:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103827:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010382d:	85 d2                	test   %edx,%edx
8010382f:	75 0a                	jne    8010383b <pipeclose+0x4b>
80103831:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103837:	85 c0                	test   %eax,%eax
80103839:	74 15                	je     80103850 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010383b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010383e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
    release(&p->lock);
80103844:	e9 b7 0f 00 00       	jmp    80104800 <release>
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	53                   	push   %ebx
80103854:	e8 a7 0f 00 00       	call   80104800 <release>
    kfree((char*)p);
80103859:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010385c:	83 c4 10             	add    $0x10,%esp
}
8010385f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103862:	5b                   	pop    %ebx
80103863:	5e                   	pop    %esi
80103864:	5d                   	pop    %ebp
    kfree((char*)p);
80103865:	e9 16 ef ff ff       	jmp    80102780 <kfree>
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103879:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103880:	00 00 00 
    wakeup(&p->nwrite);
80103883:	50                   	push   %eax
80103884:	e8 37 0b 00 00       	call   801043c0 <wakeup>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	eb 99                	jmp    80103827 <pipeclose+0x37>
8010388e:	66 90                	xchg   %ax,%ax

80103890 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 28             	sub    $0x28,%esp
80103899:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010389c:	53                   	push   %ebx
8010389d:	e8 be 0f 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
801038a2:	8b 45 10             	mov    0x10(%ebp),%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	0f 8e c0 00 00 00    	jle    80103970 <pipewrite+0xe0>
801038b0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038b3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038c2:	03 45 10             	add    0x10(%ebp),%eax
801038c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038ce:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038d4:	89 ca                	mov    %ecx,%edx
801038d6:	05 00 02 00 00       	add    $0x200,%eax
801038db:	39 c1                	cmp    %eax,%ecx
801038dd:	74 3f                	je     8010391e <pipewrite+0x8e>
801038df:	eb 67                	jmp    80103948 <pipewrite+0xb8>
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801038e8:	e8 43 03 00 00       	call   80103c30 <myproc>
801038ed:	8b 48 24             	mov    0x24(%eax),%ecx
801038f0:	85 c9                	test   %ecx,%ecx
801038f2:	75 34                	jne    80103928 <pipewrite+0x98>
      wakeup(&p->nread);
801038f4:	83 ec 0c             	sub    $0xc,%esp
801038f7:	57                   	push   %edi
801038f8:	e8 c3 0a 00 00       	call   801043c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038fd:	58                   	pop    %eax
801038fe:	5a                   	pop    %edx
801038ff:	53                   	push   %ebx
80103900:	56                   	push   %esi
80103901:	e8 fa 09 00 00       	call   80104300 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103906:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010390c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103912:	83 c4 10             	add    $0x10,%esp
80103915:	05 00 02 00 00       	add    $0x200,%eax
8010391a:	39 c2                	cmp    %eax,%edx
8010391c:	75 2a                	jne    80103948 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010391e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103924:	85 c0                	test   %eax,%eax
80103926:	75 c0                	jne    801038e8 <pipewrite+0x58>
        release(&p->lock);
80103928:	83 ec 0c             	sub    $0xc,%esp
8010392b:	53                   	push   %ebx
8010392c:	e8 cf 0e 00 00       	call   80104800 <release>
        return -1;
80103931:	83 c4 10             	add    $0x10,%esp
80103934:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103939:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010393c:	5b                   	pop    %ebx
8010393d:	5e                   	pop    %esi
8010393e:	5f                   	pop    %edi
8010393f:	5d                   	pop    %ebp
80103940:	c3                   	ret    
80103941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103948:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010394b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010394e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103954:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010395a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010395d:	83 c6 01             	add    $0x1,%esi
80103960:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103963:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103967:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010396a:	0f 85 58 ff ff ff    	jne    801038c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103979:	50                   	push   %eax
8010397a:	e8 41 0a 00 00       	call   801043c0 <wakeup>
  release(&p->lock);
8010397f:	89 1c 24             	mov    %ebx,(%esp)
80103982:	e8 79 0e 00 00       	call   80104800 <release>
  return n;
80103987:	8b 45 10             	mov    0x10(%ebp),%eax
8010398a:	83 c4 10             	add    $0x10,%esp
8010398d:	eb aa                	jmp    80103939 <pipewrite+0xa9>
8010398f:	90                   	nop

80103990 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 18             	sub    $0x18,%esp
80103999:	8b 75 08             	mov    0x8(%ebp),%esi
8010399c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010399f:	56                   	push   %esi
801039a0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039a6:	e8 b5 0e 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039ab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801039ba:	74 2f                	je     801039eb <piperead+0x5b>
801039bc:	eb 37                	jmp    801039f5 <piperead+0x65>
801039be:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801039c0:	e8 6b 02 00 00       	call   80103c30 <myproc>
801039c5:	8b 48 24             	mov    0x24(%eax),%ecx
801039c8:	85 c9                	test   %ecx,%ecx
801039ca:	0f 85 80 00 00 00    	jne    80103a50 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
801039d5:	e8 26 09 00 00       	call   80104300 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039da:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801039e0:	83 c4 10             	add    $0x10,%esp
801039e3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801039e9:	75 0a                	jne    801039f5 <piperead+0x65>
801039eb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801039f1:	85 c0                	test   %eax,%eax
801039f3:	75 cb                	jne    801039c0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039f5:	8b 55 10             	mov    0x10(%ebp),%edx
801039f8:	31 db                	xor    %ebx,%ebx
801039fa:	85 d2                	test   %edx,%edx
801039fc:	7f 20                	jg     80103a1e <piperead+0x8e>
801039fe:	eb 2c                	jmp    80103a2c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a00:	8d 48 01             	lea    0x1(%eax),%ecx
80103a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a16:	83 c3 01             	add    $0x1,%ebx
80103a19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a1c:	74 0e                	je     80103a2c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103a1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a2a:	75 d4                	jne    80103a00 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a2c:	83 ec 0c             	sub    $0xc,%esp
80103a2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a35:	50                   	push   %eax
80103a36:	e8 85 09 00 00       	call   801043c0 <wakeup>
  release(&p->lock);
80103a3b:	89 34 24             	mov    %esi,(%esp)
80103a3e:	e8 bd 0d 00 00       	call   80104800 <release>
  return i;
80103a43:	83 c4 10             	add    $0x10,%esp
}
80103a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a49:	89 d8                	mov    %ebx,%eax
80103a4b:	5b                   	pop    %ebx
80103a4c:	5e                   	pop    %esi
80103a4d:	5f                   	pop    %edi
80103a4e:	5d                   	pop    %ebp
80103a4f:	c3                   	ret    
      release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a58:	56                   	push   %esi
80103a59:	e8 a2 0d 00 00       	call   80104800 <release>
      return -1;
80103a5e:	83 c4 10             	add    $0x10,%esp
}
80103a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a64:	89 d8                	mov    %ebx,%eax
80103a66:	5b                   	pop    %ebx
80103a67:	5e                   	pop    %esi
80103a68:	5f                   	pop    %edi
80103a69:	5d                   	pop    %ebp
80103a6a:	c3                   	ret    
80103a6b:	66 90                	xchg   %ax,%ax
80103a6d:	66 90                	xchg   %ax,%ax
80103a6f:	90                   	nop

80103a70 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a74:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
{
80103a79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a7c:	68 c0 1d 11 80       	push   $0x80111dc0
80103a81:	e8 da 0d 00 00       	call   80104860 <acquire>
80103a86:	83 c4 10             	add    $0x10,%esp
80103a89:	eb 10                	jmp    80103a9b <allocproc+0x2b>
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a90:	83 c3 7c             	add    $0x7c,%ebx
80103a93:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
80103a99:	74 75                	je     80103b10 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a9b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a9e:	85 c0                	test   %eax,%eax
80103aa0:	75 ee                	jne    80103a90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103aa2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103aa7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103aaa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ab1:	89 43 10             	mov    %eax,0x10(%ebx)
80103ab4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103ab7:	68 c0 1d 11 80       	push   $0x80111dc0
  p->pid = nextpid++;
80103abc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103ac2:	e8 39 0d 00 00       	call   80104800 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ac7:	e8 74 ee ff ff       	call   80102940 <kalloc>
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	89 43 08             	mov    %eax,0x8(%ebx)
80103ad2:	85 c0                	test   %eax,%eax
80103ad4:	74 53                	je     80103b29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ad6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103adc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103adf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ae4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ae7:	c7 40 14 12 5b 10 80 	movl   $0x80105b12,0x14(%eax)
  p->context = (struct context*)sp;
80103aee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103af1:	6a 14                	push   $0x14
80103af3:	6a 00                	push   $0x0
80103af5:	50                   	push   %eax
80103af6:	e8 25 0e 00 00       	call   80104920 <memset>
  p->context->eip = (uint)forkret;
80103afb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103afe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b01:	c7 40 10 40 3b 10 80 	movl   $0x80103b40,0x10(%eax)
}
80103b08:	89 d8                	mov    %ebx,%eax
80103b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b0d:	c9                   	leave  
80103b0e:	c3                   	ret    
80103b0f:	90                   	nop
  release(&ptable.lock);
80103b10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b15:	68 c0 1d 11 80       	push   $0x80111dc0
80103b1a:	e8 e1 0c 00 00       	call   80104800 <release>
}
80103b1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b21:	83 c4 10             	add    $0x10,%esp
}
80103b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b27:	c9                   	leave  
80103b28:	c3                   	ret    
    p->state = UNUSED;
80103b29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b30:	31 db                	xor    %ebx,%ebx
}
80103b32:	89 d8                	mov    %ebx,%eax
80103b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b37:	c9                   	leave  
80103b38:	c3                   	ret    
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b46:	68 c0 1d 11 80       	push   $0x80111dc0
80103b4b:	e8 b0 0c 00 00       	call   80104800 <release>

  if (first) {
80103b50:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	85 c0                	test   %eax,%eax
80103b5a:	75 04                	jne    80103b60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b5c:	c9                   	leave  
80103b5d:	c3                   	ret    
80103b5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103b60:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103b67:	00 00 00 
    iinit(ROOTDEV);
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	6a 01                	push   $0x1
80103b6f:	e8 ac dc ff ff       	call   80101820 <iinit>
    initlog(ROOTDEV);
80103b74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b7b:	e8 00 f4 ff ff       	call   80102f80 <initlog>
}
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	c9                   	leave  
80103b84:	c3                   	ret    
80103b85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b90 <pinit>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b96:	68 e0 79 10 80       	push   $0x801079e0
80103b9b:	68 c0 1d 11 80       	push   $0x80111dc0
80103ba0:	e8 eb 0a 00 00       	call   80104690 <initlock>
}
80103ba5:	83 c4 10             	add    $0x10,%esp
80103ba8:	c9                   	leave  
80103ba9:	c3                   	ret    
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <mycpu>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bb5:	9c                   	pushf  
80103bb6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bb7:	f6 c4 02             	test   $0x2,%ah
80103bba:	75 46                	jne    80103c02 <mycpu+0x52>
  apicid = lapicid();
80103bbc:	e8 ef ef ff ff       	call   80102bb0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bc1:	8b 35 24 18 11 80    	mov    0x80111824,%esi
80103bc7:	85 f6                	test   %esi,%esi
80103bc9:	7e 2a                	jle    80103bf5 <mycpu+0x45>
80103bcb:	31 d2                	xor    %edx,%edx
80103bcd:	eb 08                	jmp    80103bd7 <mycpu+0x27>
80103bcf:	90                   	nop
80103bd0:	83 c2 01             	add    $0x1,%edx
80103bd3:	39 f2                	cmp    %esi,%edx
80103bd5:	74 1e                	je     80103bf5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103bd7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103bdd:	0f b6 99 40 18 11 80 	movzbl -0x7feee7c0(%ecx),%ebx
80103be4:	39 c3                	cmp    %eax,%ebx
80103be6:	75 e8                	jne    80103bd0 <mycpu+0x20>
}
80103be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103beb:	8d 81 40 18 11 80    	lea    -0x7feee7c0(%ecx),%eax
}
80103bf1:	5b                   	pop    %ebx
80103bf2:	5e                   	pop    %esi
80103bf3:	5d                   	pop    %ebp
80103bf4:	c3                   	ret    
  panic("unknown apicid\n");
80103bf5:	83 ec 0c             	sub    $0xc,%esp
80103bf8:	68 e7 79 10 80       	push   $0x801079e7
80103bfd:	e8 7e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c02:	83 ec 0c             	sub    $0xc,%esp
80103c05:	68 c4 7a 10 80       	push   $0x80107ac4
80103c0a:	e8 71 c7 ff ff       	call   80100380 <panic>
80103c0f:	90                   	nop

80103c10 <cpuid>:
cpuid() {
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c16:	e8 95 ff ff ff       	call   80103bb0 <mycpu>
}
80103c1b:	c9                   	leave  
  return mycpu()-cpus;
80103c1c:	2d 40 18 11 80       	sub    $0x80111840,%eax
80103c21:	c1 f8 04             	sar    $0x4,%eax
80103c24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c2a:	c3                   	ret    
80103c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <myproc>:
myproc(void) {
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c37:	e8 d4 0a 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103c3c:	e8 6f ff ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
80103c41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c47:	e8 14 0b 00 00       	call   80104760 <popcli>
}
80103c4c:	89 d8                	mov    %ebx,%eax
80103c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c51:	c9                   	leave  
80103c52:	c3                   	ret    
80103c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c60 <userinit>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c67:	e8 04 fe ff ff       	call   80103a70 <allocproc>
80103c6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c6e:	a3 f4 3c 11 80       	mov    %eax,0x80113cf4
  if((p->pgdir = setupkvm()) == 0)
80103c73:	e8 88 34 00 00       	call   80107100 <setupkvm>
80103c78:	89 43 04             	mov    %eax,0x4(%ebx)
80103c7b:	85 c0                	test   %eax,%eax
80103c7d:	0f 84 bd 00 00 00    	je     80103d40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c83:	83 ec 04             	sub    $0x4,%esp
80103c86:	68 2c 00 00 00       	push   $0x2c
80103c8b:	68 60 a4 10 80       	push   $0x8010a460
80103c90:	50                   	push   %eax
80103c91:	e8 1a 31 00 00       	call   80106db0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c9f:	6a 4c                	push   $0x4c
80103ca1:	6a 00                	push   $0x0
80103ca3:	ff 73 18             	push   0x18(%ebx)
80103ca6:	e8 75 0c 00 00       	call   80104920 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cab:	8b 43 18             	mov    0x18(%ebx),%eax
80103cae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ccd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103cd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103cdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ce6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cfd:	6a 10                	push   $0x10
80103cff:	68 10 7a 10 80       	push   $0x80107a10
80103d04:	50                   	push   %eax
80103d05:	e8 d6 0d 00 00       	call   80104ae0 <safestrcpy>
  p->cwd = namei("/");
80103d0a:	c7 04 24 19 7a 10 80 	movl   $0x80107a19,(%esp)
80103d11:	e8 4a e6 ff ff       	call   80102360 <namei>
80103d16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d19:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103d20:	e8 3b 0b 00 00       	call   80104860 <acquire>
  p->state = RUNNABLE;
80103d25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d2c:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103d33:	e8 c8 0a 00 00       	call   80104800 <release>
}
80103d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d3b:	83 c4 10             	add    $0x10,%esp
80103d3e:	c9                   	leave  
80103d3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	68 f7 79 10 80       	push   $0x801079f7
80103d48:	e8 33 c6 ff ff       	call   80100380 <panic>
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi

80103d50 <growproc>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	56                   	push   %esi
80103d54:	53                   	push   %ebx
80103d55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d58:	e8 b3 09 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103d5d:	e8 4e fe ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
80103d62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d68:	e8 f3 09 00 00       	call   80104760 <popcli>
  sz = curproc->sz;
80103d6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d6f:	85 f6                	test   %esi,%esi
80103d71:	7f 1d                	jg     80103d90 <growproc+0x40>
  } else if(n < 0){
80103d73:	75 3b                	jne    80103db0 <growproc+0x60>
  switchuvm(curproc);
80103d75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d7a:	53                   	push   %ebx
80103d7b:	e8 20 2f 00 00       	call   80106ca0 <switchuvm>
  return 0;
80103d80:	83 c4 10             	add    $0x10,%esp
80103d83:	31 c0                	xor    %eax,%eax
}
80103d85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d88:	5b                   	pop    %ebx
80103d89:	5e                   	pop    %esi
80103d8a:	5d                   	pop    %ebp
80103d8b:	c3                   	ret    
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d90:	83 ec 04             	sub    $0x4,%esp
80103d93:	01 c6                	add    %eax,%esi
80103d95:	56                   	push   %esi
80103d96:	50                   	push   %eax
80103d97:	ff 73 04             	push   0x4(%ebx)
80103d9a:	e8 81 31 00 00       	call   80106f20 <allocuvm>
80103d9f:	83 c4 10             	add    $0x10,%esp
80103da2:	85 c0                	test   %eax,%eax
80103da4:	75 cf                	jne    80103d75 <growproc+0x25>
      return -1;
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	eb d8                	jmp    80103d85 <growproc+0x35>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103db0:	83 ec 04             	sub    $0x4,%esp
80103db3:	01 c6                	add    %eax,%esi
80103db5:	56                   	push   %esi
80103db6:	50                   	push   %eax
80103db7:	ff 73 04             	push   0x4(%ebx)
80103dba:	e8 91 32 00 00       	call   80107050 <deallocuvm>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 af                	jne    80103d75 <growproc+0x25>
80103dc6:	eb de                	jmp    80103da6 <growproc+0x56>
80103dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop

80103dd0 <fork>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dd9:	e8 32 09 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103dde:	e8 cd fd ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
80103de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de9:	e8 72 09 00 00       	call   80104760 <popcli>
  if((np = allocproc()) == 0){
80103dee:	e8 7d fc ff ff       	call   80103a70 <allocproc>
80103df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103df6:	85 c0                	test   %eax,%eax
80103df8:	0f 84 b7 00 00 00    	je     80103eb5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dfe:	83 ec 08             	sub    $0x8,%esp
80103e01:	ff 33                	push   (%ebx)
80103e03:	89 c7                	mov    %eax,%edi
80103e05:	ff 73 04             	push   0x4(%ebx)
80103e08:	e8 e3 33 00 00       	call   801071f0 <copyuvm>
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	89 47 04             	mov    %eax,0x4(%edi)
80103e13:	85 c0                	test   %eax,%eax
80103e15:	0f 84 a1 00 00 00    	je     80103ebc <fork+0xec>
  np->sz = curproc->sz;
80103e1b:	8b 03                	mov    (%ebx),%eax
80103e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e25:	89 c8                	mov    %ecx,%eax
80103e27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e36:	8b 40 18             	mov    0x18(%eax),%eax
80103e39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e44:	85 c0                	test   %eax,%eax
80103e46:	74 13                	je     80103e5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	50                   	push   %eax
80103e4c:	e8 0f d3 ff ff       	call   80101160 <filedup>
80103e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e5b:	83 c6 01             	add    $0x1,%esi
80103e5e:	83 fe 10             	cmp    $0x10,%esi
80103e61:	75 dd                	jne    80103e40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e6c:	e8 9f db ff ff       	call   80101a10 <idup>
80103e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	53                   	push   %ebx
80103e80:	50                   	push   %eax
80103e81:	e8 5a 0c 00 00       	call   80104ae0 <safestrcpy>
  pid = np->pid;
80103e86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e89:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103e90:	e8 cb 09 00 00       	call   80104860 <acquire>
  np->state = RUNNABLE;
80103e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e9c:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103ea3:	e8 58 09 00 00       	call   80104800 <release>
  return pid;
80103ea8:	83 c4 10             	add    $0x10,%esp
}
80103eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eae:	89 d8                	mov    %ebx,%eax
80103eb0:	5b                   	pop    %ebx
80103eb1:	5e                   	pop    %esi
80103eb2:	5f                   	pop    %edi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret    
    return -1;
80103eb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eba:	eb ef                	jmp    80103eab <fork+0xdb>
    kfree(np->kstack);
80103ebc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ebf:	83 ec 0c             	sub    $0xc,%esp
80103ec2:	ff 73 08             	push   0x8(%ebx)
80103ec5:	e8 b6 e8 ff ff       	call   80102780 <kfree>
    np->kstack = 0;
80103eca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103ed1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ed4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103edb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ee0:	eb c9                	jmp    80103eab <fork+0xdb>
80103ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <scheduler>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ef9:	e8 b2 fc ff ff       	call   80103bb0 <mycpu>
  c->proc = 0;
80103efe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f05:	00 00 00 
  struct cpu *c = mycpu();
80103f08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f0a:	8d 78 04             	lea    0x4(%eax),%edi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f10:	fb                   	sti    
    acquire(&ptable.lock);
80103f11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f14:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
    acquire(&ptable.lock);
80103f19:	68 c0 1d 11 80       	push   $0x80111dc0
80103f1e:	e8 3d 09 00 00       	call   80104860 <acquire>
80103f23:	83 c4 10             	add    $0x10,%esp
80103f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f34:	75 33                	jne    80103f69 <scheduler+0x79>
      switchuvm(p);
80103f36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f3f:	53                   	push   %ebx
80103f40:	e8 5b 2d 00 00       	call   80106ca0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f45:	58                   	pop    %eax
80103f46:	5a                   	pop    %edx
80103f47:	ff 73 1c             	push   0x1c(%ebx)
80103f4a:	57                   	push   %edi
      p->state = RUNNING;
80103f4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f52:	e8 e4 0b 00 00       	call   80104b3b <swtch>
      switchkvm();
80103f57:	e8 34 2d 00 00       	call   80106c90 <switchkvm>
      c->proc = 0;
80103f5c:	83 c4 10             	add    $0x10,%esp
80103f5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f69:	83 c3 7c             	add    $0x7c,%ebx
80103f6c:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
80103f72:	75 bc                	jne    80103f30 <scheduler+0x40>
    release(&ptable.lock);
80103f74:	83 ec 0c             	sub    $0xc,%esp
80103f77:	68 c0 1d 11 80       	push   $0x80111dc0
80103f7c:	e8 7f 08 00 00       	call   80104800 <release>
    sti();
80103f81:	83 c4 10             	add    $0x10,%esp
80103f84:	eb 8a                	jmp    80103f10 <scheduler+0x20>
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi

80103f90 <sched>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli();
80103f95:	e8 76 07 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103f9a:	e8 11 fc ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
80103f9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa5:	e8 b6 07 00 00       	call   80104760 <popcli>
  if(!holding(&ptable.lock))
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 c0 1d 11 80       	push   $0x80111dc0
80103fb2:	e8 09 08 00 00       	call   801047c0 <holding>
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 4f                	je     8010400d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fbe:	e8 ed fb ff ff       	call   80103bb0 <mycpu>
80103fc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fca:	75 68                	jne    80104034 <sched+0xa4>
  if(p->state == RUNNING)
80103fcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fd0:	74 55                	je     80104027 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fd2:	9c                   	pushf  
80103fd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fd4:	f6 c4 02             	test   $0x2,%ah
80103fd7:	75 41                	jne    8010401a <sched+0x8a>
  intena = mycpu()->intena;
80103fd9:	e8 d2 fb ff ff       	call   80103bb0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fe1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fe7:	e8 c4 fb ff ff       	call   80103bb0 <mycpu>
80103fec:	83 ec 08             	sub    $0x8,%esp
80103fef:	ff 70 04             	push   0x4(%eax)
80103ff2:	53                   	push   %ebx
80103ff3:	e8 43 0b 00 00       	call   80104b3b <swtch>
  mycpu()->intena = intena;
80103ff8:	e8 b3 fb ff ff       	call   80103bb0 <mycpu>
}
80103ffd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104000:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
8010400c:	c3                   	ret    
    panic("sched ptable.lock");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 1b 7a 10 80       	push   $0x80107a1b
80104015:	e8 66 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 47 7a 10 80       	push   $0x80107a47
80104022:	e8 59 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 39 7a 10 80       	push   $0x80107a39
8010402f:	e8 4c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104034:	83 ec 0c             	sub    $0xc,%esp
80104037:	68 2d 7a 10 80       	push   $0x80107a2d
8010403c:	e8 3f c3 ff ff       	call   80100380 <panic>
80104041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop

80104050 <exit>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104059:	e8 d2 fb ff ff       	call   80103c30 <myproc>
  if(curproc == initproc)
8010405e:	39 05 f4 3c 11 80    	cmp    %eax,0x80113cf4
80104064:	0f 84 fd 00 00 00    	je     80104167 <exit+0x117>
8010406a:	89 c3                	mov    %eax,%ebx
8010406c:	8d 70 28             	lea    0x28(%eax),%esi
8010406f:	8d 78 68             	lea    0x68(%eax),%edi
80104072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104078:	8b 06                	mov    (%esi),%eax
8010407a:	85 c0                	test   %eax,%eax
8010407c:	74 12                	je     80104090 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	50                   	push   %eax
80104082:	e8 29 d1 ff ff       	call   801011b0 <fileclose>
      curproc->ofile[fd] = 0;
80104087:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010408d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104090:	83 c6 04             	add    $0x4,%esi
80104093:	39 f7                	cmp    %esi,%edi
80104095:	75 e1                	jne    80104078 <exit+0x28>
  begin_op();
80104097:	e8 84 ef ff ff       	call   80103020 <begin_op>
  iput(curproc->cwd);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 73 68             	push   0x68(%ebx)
801040a2:	e8 c9 da ff ff       	call   80101b70 <iput>
  end_op();
801040a7:	e8 e4 ef ff ff       	call   80103090 <end_op>
  curproc->cwd = 0;
801040ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040b3:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
801040ba:	e8 a1 07 00 00       	call   80104860 <acquire>
  wakeup1(curproc->parent);
801040bf:	8b 53 14             	mov    0x14(%ebx),%edx
801040c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c5:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
801040ca:	eb 0e                	jmp    801040da <exit+0x8a>
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d0:	83 c0 7c             	add    $0x7c,%eax
801040d3:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
801040d8:	74 1c                	je     801040f6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801040da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040de:	75 f0                	jne    801040d0 <exit+0x80>
801040e0:	3b 50 20             	cmp    0x20(%eax),%edx
801040e3:	75 eb                	jne    801040d0 <exit+0x80>
      p->state = RUNNABLE;
801040e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ec:	83 c0 7c             	add    $0x7c,%eax
801040ef:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
801040f4:	75 e4                	jne    801040da <exit+0x8a>
      p->parent = initproc;
801040f6:	8b 0d f4 3c 11 80    	mov    0x80113cf4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fc:	ba f4 1d 11 80       	mov    $0x80111df4,%edx
80104101:	eb 10                	jmp    80104113 <exit+0xc3>
80104103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104107:	90                   	nop
80104108:	83 c2 7c             	add    $0x7c,%edx
8010410b:	81 fa f4 3c 11 80    	cmp    $0x80113cf4,%edx
80104111:	74 3b                	je     8010414e <exit+0xfe>
    if(p->parent == curproc){
80104113:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104116:	75 f0                	jne    80104108 <exit+0xb8>
      if(p->state == ZOMBIE)
80104118:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010411c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010411f:	75 e7                	jne    80104108 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104121:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
80104126:	eb 12                	jmp    8010413a <exit+0xea>
80104128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412f:	90                   	nop
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104138:	74 ce                	je     80104108 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <exit+0xe0>
80104140:	3b 48 20             	cmp    0x20(%eax),%ecx
80104143:	75 eb                	jne    80104130 <exit+0xe0>
      p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010414c:	eb e2                	jmp    80104130 <exit+0xe0>
  curproc->state = ZOMBIE;
8010414e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104155:	e8 36 fe ff ff       	call   80103f90 <sched>
  panic("zombie exit");
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 68 7a 10 80       	push   $0x80107a68
80104162:	e8 19 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	68 5b 7a 10 80       	push   $0x80107a5b
8010416f:	e8 0c c2 ff ff       	call   80100380 <panic>
80104174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010417f:	90                   	nop

80104180 <wait>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
  pushcli();
80104185:	e8 86 05 00 00       	call   80104710 <pushcli>
  c = mycpu();
8010418a:	e8 21 fa ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
8010418f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104195:	e8 c6 05 00 00       	call   80104760 <popcli>
  acquire(&ptable.lock);
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 c0 1d 11 80       	push   $0x80111dc0
801041a2:	e8 b9 06 00 00       	call   80104860 <acquire>
801041a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041aa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ac:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
801041b1:	eb 10                	jmp    801041c3 <wait+0x43>
801041b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b7:	90                   	nop
801041b8:	83 c3 7c             	add    $0x7c,%ebx
801041bb:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
801041c1:	74 1b                	je     801041de <wait+0x5e>
      if(p->parent != curproc)
801041c3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041c6:	75 f0                	jne    801041b8 <wait+0x38>
      if(p->state == ZOMBIE){
801041c8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041cc:	74 62                	je     80104230 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801041d1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d6:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
801041dc:	75 e5                	jne    801041c3 <wait+0x43>
    if(!havekids || curproc->killed){
801041de:	85 c0                	test   %eax,%eax
801041e0:	0f 84 a0 00 00 00    	je     80104286 <wait+0x106>
801041e6:	8b 46 24             	mov    0x24(%esi),%eax
801041e9:	85 c0                	test   %eax,%eax
801041eb:	0f 85 95 00 00 00    	jne    80104286 <wait+0x106>
  pushcli();
801041f1:	e8 1a 05 00 00       	call   80104710 <pushcli>
  c = mycpu();
801041f6:	e8 b5 f9 ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
801041fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104201:	e8 5a 05 00 00       	call   80104760 <popcli>
  if(p == 0)
80104206:	85 db                	test   %ebx,%ebx
80104208:	0f 84 8f 00 00 00    	je     8010429d <wait+0x11d>
  p->chan = chan;
8010420e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104211:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104218:	e8 73 fd ff ff       	call   80103f90 <sched>
  p->chan = 0;
8010421d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104224:	eb 84                	jmp    801041aa <wait+0x2a>
80104226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104230:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104233:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104236:	ff 73 08             	push   0x8(%ebx)
80104239:	e8 42 e5 ff ff       	call   80102780 <kfree>
        p->kstack = 0;
8010423e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104245:	5a                   	pop    %edx
80104246:	ff 73 04             	push   0x4(%ebx)
80104249:	e8 32 2e 00 00       	call   80107080 <freevm>
        p->pid = 0;
8010424e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104255:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010425c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104260:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104267:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010426e:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80104275:	e8 86 05 00 00       	call   80104800 <release>
        return pid;
8010427a:	83 c4 10             	add    $0x10,%esp
}
8010427d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104280:	89 f0                	mov    %esi,%eax
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
      release(&ptable.lock);
80104286:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104289:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010428e:	68 c0 1d 11 80       	push   $0x80111dc0
80104293:	e8 68 05 00 00       	call   80104800 <release>
      return -1;
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb e0                	jmp    8010427d <wait+0xfd>
    panic("sleep");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 74 7a 10 80       	push   $0x80107a74
801042a5:	e8 d6 c0 ff ff       	call   80100380 <panic>
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <yield>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042b7:	68 c0 1d 11 80       	push   $0x80111dc0
801042bc:	e8 9f 05 00 00       	call   80104860 <acquire>
  pushcli();
801042c1:	e8 4a 04 00 00       	call   80104710 <pushcli>
  c = mycpu();
801042c6:	e8 e5 f8 ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
801042cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d1:	e8 8a 04 00 00       	call   80104760 <popcli>
  myproc()->state = RUNNABLE;
801042d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042dd:	e8 ae fc ff ff       	call   80103f90 <sched>
  release(&ptable.lock);
801042e2:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
801042e9:	e8 12 05 00 00       	call   80104800 <release>
}
801042ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f1:	83 c4 10             	add    $0x10,%esp
801042f4:	c9                   	leave  
801042f5:	c3                   	ret    
801042f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fd:	8d 76 00             	lea    0x0(%esi),%esi

80104300 <sleep>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	8b 7d 08             	mov    0x8(%ebp),%edi
8010430c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010430f:	e8 fc 03 00 00       	call   80104710 <pushcli>
  c = mycpu();
80104314:	e8 97 f8 ff ff       	call   80103bb0 <mycpu>
  p = c->proc;
80104319:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010431f:	e8 3c 04 00 00       	call   80104760 <popcli>
  if(p == 0)
80104324:	85 db                	test   %ebx,%ebx
80104326:	0f 84 87 00 00 00    	je     801043b3 <sleep+0xb3>
  if(lk == 0)
8010432c:	85 f6                	test   %esi,%esi
8010432e:	74 76                	je     801043a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104330:	81 fe c0 1d 11 80    	cmp    $0x80111dc0,%esi
80104336:	74 50                	je     80104388 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 c0 1d 11 80       	push   $0x80111dc0
80104340:	e8 1b 05 00 00       	call   80104860 <acquire>
    release(lk);
80104345:	89 34 24             	mov    %esi,(%esp)
80104348:	e8 b3 04 00 00       	call   80104800 <release>
  p->chan = chan;
8010434d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104350:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104357:	e8 34 fc ff ff       	call   80103f90 <sched>
  p->chan = 0;
8010435c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104363:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
8010436a:	e8 91 04 00 00       	call   80104800 <release>
    acquire(lk);
8010436f:	89 75 08             	mov    %esi,0x8(%ebp)
80104372:	83 c4 10             	add    $0x10,%esp
}
80104375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104378:	5b                   	pop    %ebx
80104379:	5e                   	pop    %esi
8010437a:	5f                   	pop    %edi
8010437b:	5d                   	pop    %ebp
    acquire(lk);
8010437c:	e9 df 04 00 00       	jmp    80104860 <acquire>
80104381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104388:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010438b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104392:	e8 f9 fb ff ff       	call   80103f90 <sched>
  p->chan = 0;
80104397:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010439e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043a1:	5b                   	pop    %ebx
801043a2:	5e                   	pop    %esi
801043a3:	5f                   	pop    %edi
801043a4:	5d                   	pop    %ebp
801043a5:	c3                   	ret    
    panic("sleep without lk");
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	68 7a 7a 10 80       	push   $0x80107a7a
801043ae:	e8 cd bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 74 7a 10 80       	push   $0x80107a74
801043bb:	e8 c0 bf ff ff       	call   80100380 <panic>

801043c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ca:	68 c0 1d 11 80       	push   $0x80111dc0
801043cf:	e8 8c 04 00 00       	call   80104860 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d7:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
801043dc:	eb 0c                	jmp    801043ea <wakeup+0x2a>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	83 c0 7c             	add    $0x7c,%eax
801043e3:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
801043e8:	74 1c                	je     80104406 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043ee:	75 f0                	jne    801043e0 <wakeup+0x20>
801043f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801043f3:	75 eb                	jne    801043e0 <wakeup+0x20>
      p->state = RUNNABLE;
801043f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fc:	83 c0 7c             	add    $0x7c,%eax
801043ff:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104404:	75 e4                	jne    801043ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104406:	c7 45 08 c0 1d 11 80 	movl   $0x80111dc0,0x8(%ebp)
}
8010440d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104410:	c9                   	leave  
  release(&ptable.lock);
80104411:	e9 ea 03 00 00       	jmp    80104800 <release>
80104416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
80104427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010442a:	68 c0 1d 11 80       	push   $0x80111dc0
8010442f:	e8 2c 04 00 00       	call   80104860 <acquire>
80104434:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104437:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
8010443c:	eb 0c                	jmp    8010444a <kill+0x2a>
8010443e:	66 90                	xchg   %ax,%ax
80104440:	83 c0 7c             	add    $0x7c,%eax
80104443:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104448:	74 36                	je     80104480 <kill+0x60>
    if(p->pid == pid){
8010444a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010444d:	75 f1                	jne    80104440 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010444f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104453:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010445a:	75 07                	jne    80104463 <kill+0x43>
        p->state = RUNNABLE;
8010445c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104463:	83 ec 0c             	sub    $0xc,%esp
80104466:	68 c0 1d 11 80       	push   $0x80111dc0
8010446b:	e8 90 03 00 00       	call   80104800 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	31 c0                	xor    %eax,%eax
}
80104478:	c9                   	leave  
80104479:	c3                   	ret    
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 c0 1d 11 80       	push   $0x80111dc0
80104488:	e8 73 03 00 00       	call   80104800 <release>
}
8010448d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104490:	83 c4 10             	add    $0x10,%esp
80104493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044a8:	53                   	push   %ebx
801044a9:	bb 60 1e 11 80       	mov    $0x80111e60,%ebx
801044ae:	83 ec 3c             	sub    $0x3c,%esp
801044b1:	eb 24                	jmp    801044d7 <procdump+0x37>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 f7 7d 10 80       	push   $0x80107df7
801044c0:	e8 db c1 ff ff       	call   801006a0 <cprintf>
801044c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c8:	83 c3 7c             	add    $0x7c,%ebx
801044cb:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
801044d1:	0f 84 81 00 00 00    	je     80104558 <procdump+0xb8>
    if(p->state == UNUSED)
801044d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044da:	85 c0                	test   %eax,%eax
801044dc:	74 ea                	je     801044c8 <procdump+0x28>
      state = "???";
801044de:	ba 8b 7a 10 80       	mov    $0x80107a8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e3:	83 f8 05             	cmp    $0x5,%eax
801044e6:	77 11                	ja     801044f9 <procdump+0x59>
801044e8:	8b 14 85 ec 7a 10 80 	mov    -0x7fef8514(,%eax,4),%edx
      state = "???";
801044ef:	b8 8b 7a 10 80       	mov    $0x80107a8b,%eax
801044f4:	85 d2                	test   %edx,%edx
801044f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044f9:	53                   	push   %ebx
801044fa:	52                   	push   %edx
801044fb:	ff 73 a4             	push   -0x5c(%ebx)
801044fe:	68 8f 7a 10 80       	push   $0x80107a8f
80104503:	e8 98 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104508:	83 c4 10             	add    $0x10,%esp
8010450b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010450f:	75 a7                	jne    801044b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104511:	83 ec 08             	sub    $0x8,%esp
80104514:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104517:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010451a:	50                   	push   %eax
8010451b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010451e:	8b 40 0c             	mov    0xc(%eax),%eax
80104521:	83 c0 08             	add    $0x8,%eax
80104524:	50                   	push   %eax
80104525:	e8 86 01 00 00       	call   801046b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010452a:	83 c4 10             	add    $0x10,%esp
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
80104530:	8b 17                	mov    (%edi),%edx
80104532:	85 d2                	test   %edx,%edx
80104534:	74 82                	je     801044b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104536:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104539:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010453c:	52                   	push   %edx
8010453d:	68 a1 74 10 80       	push   $0x801074a1
80104542:	e8 59 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	39 fe                	cmp    %edi,%esi
8010454c:	75 e2                	jne    80104530 <procdump+0x90>
8010454e:	e9 65 ff ff ff       	jmp    801044b8 <procdump+0x18>
80104553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104557:	90                   	nop
  }
}
80104558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455b:	5b                   	pop    %ebx
8010455c:	5e                   	pop    %esi
8010455d:	5f                   	pop    %edi
8010455e:	5d                   	pop    %ebp
8010455f:	c3                   	ret    

80104560 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 0c             	sub    $0xc,%esp
80104567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010456a:	68 04 7b 10 80       	push   $0x80107b04
8010456f:	8d 43 04             	lea    0x4(%ebx),%eax
80104572:	50                   	push   %eax
80104573:	e8 18 01 00 00       	call   80104690 <initlock>
  lk->name = name;
80104578:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010457b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104581:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104584:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010458b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave  
80104592:	c3                   	ret    
80104593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045a8:	8d 73 04             	lea    0x4(%ebx),%esi
801045ab:	83 ec 0c             	sub    $0xc,%esp
801045ae:	56                   	push   %esi
801045af:	e8 ac 02 00 00       	call   80104860 <acquire>
  while (lk->locked) {
801045b4:	8b 13                	mov    (%ebx),%edx
801045b6:	83 c4 10             	add    $0x10,%esp
801045b9:	85 d2                	test   %edx,%edx
801045bb:	74 16                	je     801045d3 <acquiresleep+0x33>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045c0:	83 ec 08             	sub    $0x8,%esp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	e8 36 fd ff ff       	call   80104300 <sleep>
  while (lk->locked) {
801045ca:	8b 03                	mov    (%ebx),%eax
801045cc:	83 c4 10             	add    $0x10,%esp
801045cf:	85 c0                	test   %eax,%eax
801045d1:	75 ed                	jne    801045c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045d9:	e8 52 f6 ff ff       	call   80103c30 <myproc>
801045de:	8b 40 10             	mov    0x10(%eax),%eax
801045e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045ea:	5b                   	pop    %ebx
801045eb:	5e                   	pop    %esi
801045ec:	5d                   	pop    %ebp
  release(&lk->lk);
801045ed:	e9 0e 02 00 00       	jmp    80104800 <release>
801045f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104608:	8d 73 04             	lea    0x4(%ebx),%esi
8010460b:	83 ec 0c             	sub    $0xc,%esp
8010460e:	56                   	push   %esi
8010460f:	e8 4c 02 00 00       	call   80104860 <acquire>
  lk->locked = 0;
80104614:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010461a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104621:	89 1c 24             	mov    %ebx,(%esp)
80104624:	e8 97 fd ff ff       	call   801043c0 <wakeup>
  release(&lk->lk);
80104629:	89 75 08             	mov    %esi,0x8(%ebp)
8010462c:	83 c4 10             	add    $0x10,%esp
}
8010462f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104632:	5b                   	pop    %ebx
80104633:	5e                   	pop    %esi
80104634:	5d                   	pop    %ebp
  release(&lk->lk);
80104635:	e9 c6 01 00 00       	jmp    80104800 <release>
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104640 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	31 ff                	xor    %edi,%edi
80104646:	56                   	push   %esi
80104647:	53                   	push   %ebx
80104648:	83 ec 18             	sub    $0x18,%esp
8010464b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010464e:	8d 73 04             	lea    0x4(%ebx),%esi
80104651:	56                   	push   %esi
80104652:	e8 09 02 00 00       	call   80104860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104657:	8b 03                	mov    (%ebx),%eax
80104659:	83 c4 10             	add    $0x10,%esp
8010465c:	85 c0                	test   %eax,%eax
8010465e:	75 18                	jne    80104678 <holdingsleep+0x38>
  release(&lk->lk);
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	56                   	push   %esi
80104664:	e8 97 01 00 00       	call   80104800 <release>
  return r;
}
80104669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010466c:	89 f8                	mov    %edi,%eax
8010466e:	5b                   	pop    %ebx
8010466f:	5e                   	pop    %esi
80104670:	5f                   	pop    %edi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104677:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104678:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010467b:	e8 b0 f5 ff ff       	call   80103c30 <myproc>
80104680:	39 58 10             	cmp    %ebx,0x10(%eax)
80104683:	0f 94 c0             	sete   %al
80104686:	0f b6 c0             	movzbl %al,%eax
80104689:	89 c7                	mov    %eax,%edi
8010468b:	eb d3                	jmp    80104660 <holdingsleep+0x20>
8010468d:	66 90                	xchg   %ax,%ax
8010468f:	90                   	nop

80104690 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104696:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010469f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    
801046ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046b1:	31 d2                	xor    %edx,%edx
{
801046b3:	89 e5                	mov    %esp,%ebp
801046b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046bc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046cc:	77 1a                	ja     801046e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ce:	8b 58 04             	mov    0x4(%eax),%ebx
801046d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046d9:	83 fa 0a             	cmp    $0xa,%edx
801046dc:	75 e2                	jne    801046c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e1:	c9                   	leave  
801046e2:	c3                   	ret    
801046e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e7:	90                   	nop
  for(; i < 10; i++)
801046e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046eb:	8d 51 28             	lea    0x28(%ecx),%edx
801046ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046f6:	83 c0 04             	add    $0x4,%eax
801046f9:	39 d0                	cmp    %edx,%eax
801046fb:	75 f3                	jne    801046f0 <getcallerpcs+0x40>
}
801046fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104700:	c9                   	leave  
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104710 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	9c                   	pushf  
80104718:	5b                   	pop    %ebx
  asm volatile("cli");
80104719:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010471a:	e8 91 f4 ff ff       	call   80103bb0 <mycpu>
8010471f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104725:	85 c0                	test   %eax,%eax
80104727:	74 17                	je     80104740 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104729:	e8 82 f4 ff ff       	call   80103bb0 <mycpu>
8010472e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104738:	c9                   	leave  
80104739:	c3                   	ret    
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104740:	e8 6b f4 ff ff       	call   80103bb0 <mycpu>
80104745:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010474b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104751:	eb d6                	jmp    80104729 <pushcli+0x19>
80104753:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104760 <popcli>:

void
popcli(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104766:	9c                   	pushf  
80104767:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104768:	f6 c4 02             	test   $0x2,%ah
8010476b:	75 35                	jne    801047a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010476d:	e8 3e f4 ff ff       	call   80103bb0 <mycpu>
80104772:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104779:	78 34                	js     801047af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010477b:	e8 30 f4 ff ff       	call   80103bb0 <mycpu>
80104780:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104786:	85 d2                	test   %edx,%edx
80104788:	74 06                	je     80104790 <popcli+0x30>
    sti();
}
8010478a:	c9                   	leave  
8010478b:	c3                   	ret    
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104790:	e8 1b f4 ff ff       	call   80103bb0 <mycpu>
80104795:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010479b:	85 c0                	test   %eax,%eax
8010479d:	74 eb                	je     8010478a <popcli+0x2a>
  asm volatile("sti");
8010479f:	fb                   	sti    
}
801047a0:	c9                   	leave  
801047a1:	c3                   	ret    
    panic("popcli - interruptible");
801047a2:	83 ec 0c             	sub    $0xc,%esp
801047a5:	68 0f 7b 10 80       	push   $0x80107b0f
801047aa:	e8 d1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047af:	83 ec 0c             	sub    $0xc,%esp
801047b2:	68 26 7b 10 80       	push   $0x80107b26
801047b7:	e8 c4 bb ff ff       	call   80100380 <panic>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <holding>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 75 08             	mov    0x8(%ebp),%esi
801047c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ca:	e8 41 ff ff ff       	call   80104710 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047cf:	8b 06                	mov    (%esi),%eax
801047d1:	85 c0                	test   %eax,%eax
801047d3:	75 0b                	jne    801047e0 <holding+0x20>
  popcli();
801047d5:	e8 86 ff ff ff       	call   80104760 <popcli>
}
801047da:	89 d8                	mov    %ebx,%eax
801047dc:	5b                   	pop    %ebx
801047dd:	5e                   	pop    %esi
801047de:	5d                   	pop    %ebp
801047df:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801047e0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047e3:	e8 c8 f3 ff ff       	call   80103bb0 <mycpu>
801047e8:	39 c3                	cmp    %eax,%ebx
801047ea:	0f 94 c3             	sete   %bl
  popcli();
801047ed:	e8 6e ff ff ff       	call   80104760 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047f2:	0f b6 db             	movzbl %bl,%ebx
}
801047f5:	89 d8                	mov    %ebx,%eax
801047f7:	5b                   	pop    %ebx
801047f8:	5e                   	pop    %esi
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop

80104800 <release>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104808:	e8 03 ff ff ff       	call   80104710 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010480d:	8b 03                	mov    (%ebx),%eax
8010480f:	85 c0                	test   %eax,%eax
80104811:	75 15                	jne    80104828 <release+0x28>
  popcli();
80104813:	e8 48 ff ff ff       	call   80104760 <popcli>
    panic("release");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 2d 7b 10 80       	push   $0x80107b2d
80104820:	e8 5b bb ff ff       	call   80100380 <panic>
80104825:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104828:	8b 73 08             	mov    0x8(%ebx),%esi
8010482b:	e8 80 f3 ff ff       	call   80103bb0 <mycpu>
80104830:	39 c6                	cmp    %eax,%esi
80104832:	75 df                	jne    80104813 <release+0x13>
  popcli();
80104834:	e8 27 ff ff ff       	call   80104760 <popcli>
  lk->pcs[0] = 0;
80104839:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104840:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104847:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010484c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104855:	5b                   	pop    %ebx
80104856:	5e                   	pop    %esi
80104857:	5d                   	pop    %ebp
  popcli();
80104858:	e9 03 ff ff ff       	jmp    80104760 <popcli>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <acquire>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104867:	e8 a4 fe ff ff       	call   80104710 <pushcli>
  if(holding(lk))
8010486c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010486f:	e8 9c fe ff ff       	call   80104710 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104874:	8b 03                	mov    (%ebx),%eax
80104876:	85 c0                	test   %eax,%eax
80104878:	75 7e                	jne    801048f8 <acquire+0x98>
  popcli();
8010487a:	e8 e1 fe ff ff       	call   80104760 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010487f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104888:	8b 55 08             	mov    0x8(%ebp),%edx
8010488b:	89 c8                	mov    %ecx,%eax
8010488d:	f0 87 02             	lock xchg %eax,(%edx)
80104890:	85 c0                	test   %eax,%eax
80104892:	75 f4                	jne    80104888 <acquire+0x28>
  __sync_synchronize();
80104894:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104899:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010489c:	e8 0f f3 ff ff       	call   80103bb0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048a4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048a6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048a9:	31 c0                	xor    %eax,%eax
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048bc:	77 1a                	ja     801048d8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048be:	8b 5a 04             	mov    0x4(%edx),%ebx
801048c1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048c5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048c8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048ca:	83 f8 0a             	cmp    $0xa,%eax
801048cd:	75 e1                	jne    801048b0 <acquire+0x50>
}
801048cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d2:	c9                   	leave  
801048d3:	c3                   	ret    
801048d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048d8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048dc:	8d 51 34             	lea    0x34(%ecx),%edx
801048df:	90                   	nop
    pcs[i] = 0;
801048e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048e6:	83 c0 04             	add    $0x4,%eax
801048e9:	39 c2                	cmp    %eax,%edx
801048eb:	75 f3                	jne    801048e0 <acquire+0x80>
}
801048ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f0:	c9                   	leave  
801048f1:	c3                   	ret    
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048f8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801048fb:	e8 b0 f2 ff ff       	call   80103bb0 <mycpu>
80104900:	39 c3                	cmp    %eax,%ebx
80104902:	0f 85 72 ff ff ff    	jne    8010487a <acquire+0x1a>
  popcli();
80104908:	e8 53 fe ff ff       	call   80104760 <popcli>
    panic("acquire");
8010490d:	83 ec 0c             	sub    $0xc,%esp
80104910:	68 35 7b 10 80       	push   $0x80107b35
80104915:	e8 66 ba ff ff       	call   80100380 <panic>
8010491a:	66 90                	xchg   %ax,%ax
8010491c:	66 90                	xchg   %ax,%ax
8010491e:	66 90                	xchg   %ax,%ax

80104920 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	8b 55 08             	mov    0x8(%ebp),%edx
80104927:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010492a:	53                   	push   %ebx
8010492b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010492e:	89 d7                	mov    %edx,%edi
80104930:	09 cf                	or     %ecx,%edi
80104932:	83 e7 03             	and    $0x3,%edi
80104935:	75 29                	jne    80104960 <memset+0x40>
    c &= 0xFF;
80104937:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010493a:	c1 e0 18             	shl    $0x18,%eax
8010493d:	89 fb                	mov    %edi,%ebx
8010493f:	c1 e9 02             	shr    $0x2,%ecx
80104942:	c1 e3 10             	shl    $0x10,%ebx
80104945:	09 d8                	or     %ebx,%eax
80104947:	09 f8                	or     %edi,%eax
80104949:	c1 e7 08             	shl    $0x8,%edi
8010494c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010494e:	89 d7                	mov    %edx,%edi
80104950:	fc                   	cld    
80104951:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104953:	5b                   	pop    %ebx
80104954:	89 d0                	mov    %edx,%eax
80104956:	5f                   	pop    %edi
80104957:	5d                   	pop    %ebp
80104958:	c3                   	ret    
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104960:	89 d7                	mov    %edx,%edi
80104962:	fc                   	cld    
80104963:	f3 aa                	rep stos %al,%es:(%edi)
80104965:	5b                   	pop    %ebx
80104966:	89 d0                	mov    %edx,%eax
80104968:	5f                   	pop    %edi
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop

80104970 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	8b 75 10             	mov    0x10(%ebp),%esi
80104977:	8b 55 08             	mov    0x8(%ebp),%edx
8010497a:	53                   	push   %ebx
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010497e:	85 f6                	test   %esi,%esi
80104980:	74 2e                	je     801049b0 <memcmp+0x40>
80104982:	01 c6                	add    %eax,%esi
80104984:	eb 14                	jmp    8010499a <memcmp+0x2a>
80104986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104990:	83 c0 01             	add    $0x1,%eax
80104993:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104996:	39 f0                	cmp    %esi,%eax
80104998:	74 16                	je     801049b0 <memcmp+0x40>
    if(*s1 != *s2)
8010499a:	0f b6 0a             	movzbl (%edx),%ecx
8010499d:	0f b6 18             	movzbl (%eax),%ebx
801049a0:	38 d9                	cmp    %bl,%cl
801049a2:	74 ec                	je     80104990 <memcmp+0x20>
      return *s1 - *s2;
801049a4:	0f b6 c1             	movzbl %cl,%eax
801049a7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	5b                   	pop    %ebx
  return 0;
801049b1:	31 c0                	xor    %eax,%eax
}
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	8b 55 08             	mov    0x8(%ebp),%edx
801049c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ca:	56                   	push   %esi
801049cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ce:	39 d6                	cmp    %edx,%esi
801049d0:	73 26                	jae    801049f8 <memmove+0x38>
801049d2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049d5:	39 fa                	cmp    %edi,%edx
801049d7:	73 1f                	jae    801049f8 <memmove+0x38>
801049d9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049dc:	85 c9                	test   %ecx,%ecx
801049de:	74 0c                	je     801049ec <memmove+0x2c>
      *--d = *--s;
801049e0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049e4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049e7:	83 e8 01             	sub    $0x1,%eax
801049ea:	73 f4                	jae    801049e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ec:	5e                   	pop    %esi
801049ed:	89 d0                	mov    %edx,%eax
801049ef:	5f                   	pop    %edi
801049f0:	5d                   	pop    %ebp
801049f1:	c3                   	ret    
801049f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049f8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049fb:	89 d7                	mov    %edx,%edi
801049fd:	85 c9                	test   %ecx,%ecx
801049ff:	74 eb                	je     801049ec <memmove+0x2c>
80104a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a08:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a09:	39 c6                	cmp    %eax,%esi
80104a0b:	75 fb                	jne    80104a08 <memmove+0x48>
}
80104a0d:	5e                   	pop    %esi
80104a0e:	89 d0                	mov    %edx,%eax
80104a10:	5f                   	pop    %edi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a20:	eb 9e                	jmp    801049c0 <memmove>
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	8b 75 10             	mov    0x10(%ebp),%esi
80104a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a3a:	53                   	push   %ebx
80104a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a3e:	85 f6                	test   %esi,%esi
80104a40:	74 2e                	je     80104a70 <strncmp+0x40>
80104a42:	01 d6                	add    %edx,%esi
80104a44:	eb 18                	jmp    80104a5e <strncmp+0x2e>
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
80104a50:	38 d8                	cmp    %bl,%al
80104a52:	75 14                	jne    80104a68 <strncmp+0x38>
    n--, p++, q++;
80104a54:	83 c2 01             	add    $0x1,%edx
80104a57:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a5a:	39 f2                	cmp    %esi,%edx
80104a5c:	74 12                	je     80104a70 <strncmp+0x40>
80104a5e:	0f b6 01             	movzbl (%ecx),%eax
80104a61:	0f b6 1a             	movzbl (%edx),%ebx
80104a64:	84 c0                	test   %al,%al
80104a66:	75 e8                	jne    80104a50 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a68:	29 d8                	sub    %ebx,%eax
}
80104a6a:	5b                   	pop    %ebx
80104a6b:	5e                   	pop    %esi
80104a6c:	5d                   	pop    %ebp
80104a6d:	c3                   	ret    
80104a6e:	66 90                	xchg   %ax,%ax
80104a70:	5b                   	pop    %ebx
    return 0;
80104a71:	31 c0                	xor    %eax,%eax
}
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	56                   	push   %esi
80104a85:	8b 75 08             	mov    0x8(%ebp),%esi
80104a88:	53                   	push   %ebx
80104a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a8c:	89 f0                	mov    %esi,%eax
80104a8e:	eb 15                	jmp    80104aa5 <strncpy+0x25>
80104a90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a94:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a97:	83 c0 01             	add    $0x1,%eax
80104a9a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104a9e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104aa1:	84 d2                	test   %dl,%dl
80104aa3:	74 09                	je     80104aae <strncpy+0x2e>
80104aa5:	89 cb                	mov    %ecx,%ebx
80104aa7:	83 e9 01             	sub    $0x1,%ecx
80104aaa:	85 db                	test   %ebx,%ebx
80104aac:	7f e2                	jg     80104a90 <strncpy+0x10>
    ;
  while(n-- > 0)
80104aae:	89 c2                	mov    %eax,%edx
80104ab0:	85 c9                	test   %ecx,%ecx
80104ab2:	7e 17                	jle    80104acb <strncpy+0x4b>
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ab8:	83 c2 01             	add    $0x1,%edx
80104abb:	89 c1                	mov    %eax,%ecx
80104abd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104ac1:	29 d1                	sub    %edx,%ecx
80104ac3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ac7:	85 c9                	test   %ecx,%ecx
80104ac9:	7f ed                	jg     80104ab8 <strncpy+0x38>
  return os;
}
80104acb:	5b                   	pop    %ebx
80104acc:	89 f0                	mov    %esi,%eax
80104ace:	5e                   	pop    %esi
80104acf:	5f                   	pop    %edi
80104ad0:	5d                   	pop    %ebp
80104ad1:	c3                   	ret    
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ae7:	8b 75 08             	mov    0x8(%ebp),%esi
80104aea:	53                   	push   %ebx
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104aee:	85 d2                	test   %edx,%edx
80104af0:	7e 25                	jle    80104b17 <safestrcpy+0x37>
80104af2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104af6:	89 f2                	mov    %esi,%edx
80104af8:	eb 16                	jmp    80104b10 <safestrcpy+0x30>
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b00:	0f b6 08             	movzbl (%eax),%ecx
80104b03:	83 c0 01             	add    $0x1,%eax
80104b06:	83 c2 01             	add    $0x1,%edx
80104b09:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b0c:	84 c9                	test   %cl,%cl
80104b0e:	74 04                	je     80104b14 <safestrcpy+0x34>
80104b10:	39 d8                	cmp    %ebx,%eax
80104b12:	75 ec                	jne    80104b00 <safestrcpy+0x20>
    ;
  *s = 0;
80104b14:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b17:	89 f0                	mov    %esi,%eax
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5d                   	pop    %ebp
80104b1c:	c3                   	ret    
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi

80104b20 <strlen>:

int
strlen(const char *s)
{
80104b20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b21:	31 c0                	xor    %eax,%eax
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b28:	80 3a 00             	cmpb   $0x0,(%edx)
80104b2b:	74 0c                	je     80104b39 <strlen+0x19>
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
80104b30:	83 c0 01             	add    $0x1,%eax
80104b33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b37:	75 f7                	jne    80104b30 <strlen+0x10>
    ;
  return n;
}
80104b39:	5d                   	pop    %ebp
80104b3a:	c3                   	ret    

80104b3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b43:	55                   	push   %ebp
  pushl %ebx
80104b44:	53                   	push   %ebx
  pushl %esi
80104b45:	56                   	push   %esi
  pushl %edi
80104b46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b4b:	5f                   	pop    %edi
  popl %esi
80104b4c:	5e                   	pop    %esi
  popl %ebx
80104b4d:	5b                   	pop    %ebx
  popl %ebp
80104b4e:	5d                   	pop    %ebp
  ret
80104b4f:	c3                   	ret    

80104b50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 04             	sub    $0x4,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b5a:	e8 d1 f0 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b5f:	8b 00                	mov    (%eax),%eax
80104b61:	39 d8                	cmp    %ebx,%eax
80104b63:	76 1b                	jbe    80104b80 <fetchint+0x30>
80104b65:	8d 53 04             	lea    0x4(%ebx),%edx
80104b68:	39 d0                	cmp    %edx,%eax
80104b6a:	72 14                	jb     80104b80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6f:	8b 13                	mov    (%ebx),%edx
80104b71:	89 10                	mov    %edx,(%eax)
  return 0;
80104b73:	31 c0                	xor    %eax,%eax
}
80104b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b78:	c9                   	leave  
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b85:	eb ee                	jmp    80104b75 <fetchint+0x25>
80104b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b9a:	e8 91 f0 ff ff       	call   80103c30 <myproc>

  if(addr >= curproc->sz)
80104b9f:	39 18                	cmp    %ebx,(%eax)
80104ba1:	76 2d                	jbe    80104bd0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ba6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ba8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104baa:	39 d3                	cmp    %edx,%ebx
80104bac:	73 22                	jae    80104bd0 <fetchstr+0x40>
80104bae:	89 d8                	mov    %ebx,%eax
80104bb0:	eb 0d                	jmp    80104bbf <fetchstr+0x2f>
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb8:	83 c0 01             	add    $0x1,%eax
80104bbb:	39 c2                	cmp    %eax,%edx
80104bbd:	76 11                	jbe    80104bd0 <fetchstr+0x40>
    if(*s == 0)
80104bbf:	80 38 00             	cmpb   $0x0,(%eax)
80104bc2:	75 f4                	jne    80104bb8 <fetchstr+0x28>
      return s - *pp;
80104bc4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc9:	c9                   	leave  
80104bca:	c3                   	ret    
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
80104bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd8:	c9                   	leave  
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104be0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be5:	e8 46 f0 ff ff       	call   80103c30 <myproc>
80104bea:	8b 55 08             	mov    0x8(%ebp),%edx
80104bed:	8b 40 18             	mov    0x18(%eax),%eax
80104bf0:	8b 40 44             	mov    0x44(%eax),%eax
80104bf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bf6:	e8 35 f0 ff ff       	call   80103c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bfe:	8b 00                	mov    (%eax),%eax
80104c00:	39 c6                	cmp    %eax,%esi
80104c02:	73 1c                	jae    80104c20 <argint+0x40>
80104c04:	8d 53 08             	lea    0x8(%ebx),%edx
80104c07:	39 d0                	cmp    %edx,%eax
80104c09:	72 15                	jb     80104c20 <argint+0x40>
  *ip = *(int*)(addr);
80104c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c11:	89 10                	mov    %edx,(%eax)
  return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	5b                   	pop    %ebx
80104c16:	5e                   	pop    %esi
80104c17:	5d                   	pop    %ebp
80104c18:	c3                   	ret    
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	eb ee                	jmp    80104c15 <argint+0x35>
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	53                   	push   %ebx
80104c36:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c39:	e8 f2 ef ff ff       	call   80103c30 <myproc>
80104c3e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c40:	e8 eb ef ff ff       	call   80103c30 <myproc>
80104c45:	8b 55 08             	mov    0x8(%ebp),%edx
80104c48:	8b 40 18             	mov    0x18(%eax),%eax
80104c4b:	8b 40 44             	mov    0x44(%eax),%eax
80104c4e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c51:	e8 da ef ff ff       	call   80103c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c56:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c59:	8b 00                	mov    (%eax),%eax
80104c5b:	39 c7                	cmp    %eax,%edi
80104c5d:	73 31                	jae    80104c90 <argptr+0x60>
80104c5f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c62:	39 c8                	cmp    %ecx,%eax
80104c64:	72 2a                	jb     80104c90 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c66:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c69:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c6c:	85 d2                	test   %edx,%edx
80104c6e:	78 20                	js     80104c90 <argptr+0x60>
80104c70:	8b 16                	mov    (%esi),%edx
80104c72:	39 c2                	cmp    %eax,%edx
80104c74:	76 1a                	jbe    80104c90 <argptr+0x60>
80104c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c79:	01 c3                	add    %eax,%ebx
80104c7b:	39 da                	cmp    %ebx,%edx
80104c7d:	72 11                	jb     80104c90 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c82:	89 02                	mov    %eax,(%edx)
  return 0;
80104c84:	31 c0                	xor    %eax,%eax
}
80104c86:	83 c4 0c             	add    $0xc,%esp
80104c89:	5b                   	pop    %ebx
80104c8a:	5e                   	pop    %esi
80104c8b:	5f                   	pop    %edi
80104c8c:	5d                   	pop    %ebp
80104c8d:	c3                   	ret    
80104c8e:	66 90                	xchg   %ax,%ax
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c95:	eb ef                	jmp    80104c86 <argptr+0x56>
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca5:	e8 86 ef ff ff       	call   80103c30 <myproc>
80104caa:	8b 55 08             	mov    0x8(%ebp),%edx
80104cad:	8b 40 18             	mov    0x18(%eax),%eax
80104cb0:	8b 40 44             	mov    0x44(%eax),%eax
80104cb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cb6:	e8 75 ef ff ff       	call   80103c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cbe:	8b 00                	mov    (%eax),%eax
80104cc0:	39 c6                	cmp    %eax,%esi
80104cc2:	73 44                	jae    80104d08 <argstr+0x68>
80104cc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cc7:	39 d0                	cmp    %edx,%eax
80104cc9:	72 3d                	jb     80104d08 <argstr+0x68>
  *ip = *(int*)(addr);
80104ccb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cce:	e8 5d ef ff ff       	call   80103c30 <myproc>
  if(addr >= curproc->sz)
80104cd3:	3b 18                	cmp    (%eax),%ebx
80104cd5:	73 31                	jae    80104d08 <argstr+0x68>
  *pp = (char*)addr;
80104cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cdc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cde:	39 d3                	cmp    %edx,%ebx
80104ce0:	73 26                	jae    80104d08 <argstr+0x68>
80104ce2:	89 d8                	mov    %ebx,%eax
80104ce4:	eb 11                	jmp    80104cf7 <argstr+0x57>
80104ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ced:	8d 76 00             	lea    0x0(%esi),%esi
80104cf0:	83 c0 01             	add    $0x1,%eax
80104cf3:	39 c2                	cmp    %eax,%edx
80104cf5:	76 11                	jbe    80104d08 <argstr+0x68>
    if(*s == 0)
80104cf7:	80 38 00             	cmpb   $0x0,(%eax)
80104cfa:	75 f4                	jne    80104cf0 <argstr+0x50>
      return s - *pp;
80104cfc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cfe:	5b                   	pop    %ebx
80104cff:	5e                   	pop    %esi
80104d00:	5d                   	pop    %ebp
80104d01:	c3                   	ret    
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d08:	5b                   	pop    %ebx
    return -1;
80104d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d0e:	5e                   	pop    %esi
80104d0f:	5d                   	pop    %ebp
80104d10:	c3                   	ret    
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d27:	e8 04 ef ff ff       	call   80103c30 <myproc>
80104d2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d2e:	8b 40 18             	mov    0x18(%eax),%eax
80104d31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d37:	83 fa 14             	cmp    $0x14,%edx
80104d3a:	77 24                	ja     80104d60 <syscall+0x40>
80104d3c:	8b 14 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%edx
80104d43:	85 d2                	test   %edx,%edx
80104d45:	74 19                	je     80104d60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d47:	ff d2                	call   *%edx
80104d49:	89 c2                	mov    %eax,%edx
80104d4b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d4e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d54:	c9                   	leave  
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d64:	50                   	push   %eax
80104d65:	ff 73 10             	push   0x10(%ebx)
80104d68:	68 3d 7b 10 80       	push   $0x80107b3d
80104d6d:	e8 2e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d72:	8b 43 18             	mov    0x18(%ebx),%eax
80104d75:	83 c4 10             	add    $0x10,%esp
80104d78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d82:	c9                   	leave  
80104d83:	c3                   	ret    
80104d84:	66 90                	xchg   %ax,%ax
80104d86:	66 90                	xchg   %ax,%ax
80104d88:	66 90                	xchg   %ax,%ax
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d98:	53                   	push   %ebx
80104d99:	83 ec 34             	sub    $0x34,%esp
80104d9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104da2:	57                   	push   %edi
80104da3:	50                   	push   %eax
{
80104da4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104da7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104daa:	e8 d1 d5 ff ff       	call   80102380 <nameiparent>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	0f 84 46 01 00 00    	je     80104f00 <create+0x170>
    return 0;
  ilock(dp);
80104dba:	83 ec 0c             	sub    $0xc,%esp
80104dbd:	89 c3                	mov    %eax,%ebx
80104dbf:	50                   	push   %eax
80104dc0:	e8 7b cc ff ff       	call   80101a40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104dc5:	83 c4 0c             	add    $0xc,%esp
80104dc8:	6a 00                	push   $0x0
80104dca:	57                   	push   %edi
80104dcb:	53                   	push   %ebx
80104dcc:	e8 cf d1 ff ff       	call   80101fa0 <dirlookup>
80104dd1:	83 c4 10             	add    $0x10,%esp
80104dd4:	89 c6                	mov    %eax,%esi
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	74 56                	je     80104e30 <create+0xa0>
    iunlockput(dp);
80104dda:	83 ec 0c             	sub    $0xc,%esp
80104ddd:	53                   	push   %ebx
80104dde:	e8 ed ce ff ff       	call   80101cd0 <iunlockput>
    ilock(ip);
80104de3:	89 34 24             	mov    %esi,(%esp)
80104de6:	e8 55 cc ff ff       	call   80101a40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104deb:	83 c4 10             	add    $0x10,%esp
80104dee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104df3:	75 1b                	jne    80104e10 <create+0x80>
80104df5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dfa:	75 14                	jne    80104e10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dff:	89 f0                	mov    %esi,%eax
80104e01:	5b                   	pop    %ebx
80104e02:	5e                   	pop    %esi
80104e03:	5f                   	pop    %edi
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e10:	83 ec 0c             	sub    $0xc,%esp
80104e13:	56                   	push   %esi
    return 0;
80104e14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e16:	e8 b5 ce ff ff       	call   80101cd0 <iunlockput>
    return 0;
80104e1b:	83 c4 10             	add    $0x10,%esp
}
80104e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e21:	89 f0                	mov    %esi,%eax
80104e23:	5b                   	pop    %ebx
80104e24:	5e                   	pop    %esi
80104e25:	5f                   	pop    %edi
80104e26:	5d                   	pop    %ebp
80104e27:	c3                   	ret    
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e34:	83 ec 08             	sub    $0x8,%esp
80104e37:	50                   	push   %eax
80104e38:	ff 33                	push   (%ebx)
80104e3a:	e8 91 ca ff ff       	call   801018d0 <ialloc>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	89 c6                	mov    %eax,%esi
80104e44:	85 c0                	test   %eax,%eax
80104e46:	0f 84 cd 00 00 00    	je     80104f19 <create+0x189>
  ilock(ip);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	50                   	push   %eax
80104e50:	e8 eb cb ff ff       	call   80101a40 <ilock>
  ip->major = major;
80104e55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e65:	b8 01 00 00 00       	mov    $0x1,%eax
80104e6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e6e:	89 34 24             	mov    %esi,(%esp)
80104e71:	e8 1a cb ff ff       	call   80101990 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104e7e:	74 30                	je     80104eb0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e80:	83 ec 04             	sub    $0x4,%esp
80104e83:	ff 76 04             	push   0x4(%esi)
80104e86:	57                   	push   %edi
80104e87:	53                   	push   %ebx
80104e88:	e8 13 d4 ff ff       	call   801022a0 <dirlink>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 78                	js     80104f0c <create+0x17c>
  iunlockput(dp);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	53                   	push   %ebx
80104e98:	e8 33 ce ff ff       	call   80101cd0 <iunlockput>
  return ip;
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea3:	89 f0                	mov    %esi,%eax
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5f                   	pop    %edi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret    
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104eb8:	53                   	push   %ebx
80104eb9:	e8 d2 ca ff ff       	call   80101990 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104ebe:	83 c4 0c             	add    $0xc,%esp
80104ec1:	ff 76 04             	push   0x4(%esi)
80104ec4:	68 d4 7b 10 80       	push   $0x80107bd4
80104ec9:	56                   	push   %esi
80104eca:	e8 d1 d3 ff ff       	call   801022a0 <dirlink>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	78 18                	js     80104eee <create+0x15e>
80104ed6:	83 ec 04             	sub    $0x4,%esp
80104ed9:	ff 73 04             	push   0x4(%ebx)
80104edc:	68 d3 7b 10 80       	push   $0x80107bd3
80104ee1:	56                   	push   %esi
80104ee2:	e8 b9 d3 ff ff       	call   801022a0 <dirlink>
80104ee7:	83 c4 10             	add    $0x10,%esp
80104eea:	85 c0                	test   %eax,%eax
80104eec:	79 92                	jns    80104e80 <create+0xf0>
      panic("create dots");
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 c7 7b 10 80       	push   $0x80107bc7
80104ef6:	e8 85 b4 ff ff       	call   80100380 <panic>
80104efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop
}
80104f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f03:	31 f6                	xor    %esi,%esi
}
80104f05:	5b                   	pop    %ebx
80104f06:	89 f0                	mov    %esi,%eax
80104f08:	5e                   	pop    %esi
80104f09:	5f                   	pop    %edi
80104f0a:	5d                   	pop    %ebp
80104f0b:	c3                   	ret    
    panic("create: dirlink");
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	68 d6 7b 10 80       	push   $0x80107bd6
80104f14:	e8 67 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f19:	83 ec 0c             	sub    $0xc,%esp
80104f1c:	68 b8 7b 10 80       	push   $0x80107bb8
80104f21:	e8 5a b4 ff ff       	call   80100380 <panic>
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi

80104f30 <sys_dup>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f3b:	50                   	push   %eax
80104f3c:	6a 00                	push   $0x0
80104f3e:	e8 9d fc ff ff       	call   80104be0 <argint>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 36                	js     80104f80 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f4e:	77 30                	ja     80104f80 <sys_dup+0x50>
80104f50:	e8 db ec ff ff       	call   80103c30 <myproc>
80104f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f5c:	85 f6                	test   %esi,%esi
80104f5e:	74 20                	je     80104f80 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f60:	e8 cb ec ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f65:	31 db                	xor    %ebx,%ebx
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f74:	85 d2                	test   %edx,%edx
80104f76:	74 18                	je     80104f90 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f78:	83 c3 01             	add    $0x1,%ebx
80104f7b:	83 fb 10             	cmp    $0x10,%ebx
80104f7e:	75 f0                	jne    80104f70 <sys_dup+0x40>
}
80104f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f88:	89 d8                	mov    %ebx,%eax
80104f8a:	5b                   	pop    %ebx
80104f8b:	5e                   	pop    %esi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret    
80104f8e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f90:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f93:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f97:	56                   	push   %esi
80104f98:	e8 c3 c1 ff ff       	call   80101160 <filedup>
  return fd;
80104f9d:	83 c4 10             	add    $0x10,%esp
}
80104fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa3:	89 d8                	mov    %ebx,%eax
80104fa5:	5b                   	pop    %ebx
80104fa6:	5e                   	pop    %esi
80104fa7:	5d                   	pop    %ebp
80104fa8:	c3                   	ret    
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <sys_read>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 00                	push   $0x0
80104fbe:	e8 1d fc ff ff       	call   80104be0 <argint>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 5e                	js     80105028 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fce:	77 58                	ja     80105028 <sys_read+0x78>
80104fd0:	e8 5b ec ff ff       	call   80103c30 <myproc>
80104fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fdc:	85 f6                	test   %esi,%esi
80104fde:	74 48                	je     80105028 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe0:	83 ec 08             	sub    $0x8,%esp
80104fe3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fe6:	50                   	push   %eax
80104fe7:	6a 02                	push   $0x2
80104fe9:	e8 f2 fb ff ff       	call   80104be0 <argint>
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	78 33                	js     80105028 <sys_read+0x78>
80104ff5:	83 ec 04             	sub    $0x4,%esp
80104ff8:	ff 75 f0             	push   -0x10(%ebp)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 01                	push   $0x1
80104ffe:	e8 2d fc ff ff       	call   80104c30 <argptr>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 1e                	js     80105028 <sys_read+0x78>
  return fileread(f, p, n);
8010500a:	83 ec 04             	sub    $0x4,%esp
8010500d:	ff 75 f0             	push   -0x10(%ebp)
80105010:	ff 75 f4             	push   -0xc(%ebp)
80105013:	56                   	push   %esi
80105014:	e8 c7 c2 ff ff       	call   801012e0 <fileread>
80105019:	83 c4 10             	add    $0x10,%esp
}
8010501c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105027:	90                   	nop
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ed                	jmp    8010501c <sys_read+0x6c>
8010502f:	90                   	nop

80105030 <sys_write>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	53                   	push   %ebx
8010503c:	6a 00                	push   $0x0
8010503e:	e8 9d fb ff ff       	call   80104be0 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 5e                	js     801050a8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 58                	ja     801050a8 <sys_write+0x78>
80105050:	e8 db eb ff ff       	call   80103c30 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010505c:	85 f6                	test   %esi,%esi
8010505e:	74 48                	je     801050a8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105060:	83 ec 08             	sub    $0x8,%esp
80105063:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105066:	50                   	push   %eax
80105067:	6a 02                	push   $0x2
80105069:	e8 72 fb ff ff       	call   80104be0 <argint>
8010506e:	83 c4 10             	add    $0x10,%esp
80105071:	85 c0                	test   %eax,%eax
80105073:	78 33                	js     801050a8 <sys_write+0x78>
80105075:	83 ec 04             	sub    $0x4,%esp
80105078:	ff 75 f0             	push   -0x10(%ebp)
8010507b:	53                   	push   %ebx
8010507c:	6a 01                	push   $0x1
8010507e:	e8 ad fb ff ff       	call   80104c30 <argptr>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 1e                	js     801050a8 <sys_write+0x78>
  return filewrite(f, p, n);
8010508a:	83 ec 04             	sub    $0x4,%esp
8010508d:	ff 75 f0             	push   -0x10(%ebp)
80105090:	ff 75 f4             	push   -0xc(%ebp)
80105093:	56                   	push   %esi
80105094:	e8 d7 c2 ff ff       	call   80101370 <filewrite>
80105099:	83 c4 10             	add    $0x10,%esp
}
8010509c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010509f:	5b                   	pop    %ebx
801050a0:	5e                   	pop    %esi
801050a1:	5d                   	pop    %ebp
801050a2:	c3                   	ret    
801050a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050a7:	90                   	nop
    return -1;
801050a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ad:	eb ed                	jmp    8010509c <sys_write+0x6c>
801050af:	90                   	nop

801050b0 <sys_close>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050bb:	50                   	push   %eax
801050bc:	6a 00                	push   $0x0
801050be:	e8 1d fb ff ff       	call   80104be0 <argint>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 3e                	js     80105108 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ce:	77 38                	ja     80105108 <sys_close+0x58>
801050d0:	e8 5b eb ff ff       	call   80103c30 <myproc>
801050d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050db:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050df:	85 f6                	test   %esi,%esi
801050e1:	74 25                	je     80105108 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050e3:	e8 48 eb ff ff       	call   80103c30 <myproc>
  fileclose(f);
801050e8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050eb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050f2:	00 
  fileclose(f);
801050f3:	56                   	push   %esi
801050f4:	e8 b7 c0 ff ff       	call   801011b0 <fileclose>
  return 0;
801050f9:	83 c4 10             	add    $0x10,%esp
801050fc:	31 c0                	xor    %eax,%eax
}
801050fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105101:	5b                   	pop    %ebx
80105102:	5e                   	pop    %esi
80105103:	5d                   	pop    %ebp
80105104:	c3                   	ret    
80105105:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb ef                	jmp    801050fe <sys_close+0x4e>
8010510f:	90                   	nop

80105110 <sys_fstat>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105115:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105118:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511b:	53                   	push   %ebx
8010511c:	6a 00                	push   $0x0
8010511e:	e8 bd fa ff ff       	call   80104be0 <argint>
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	85 c0                	test   %eax,%eax
80105128:	78 46                	js     80105170 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010512e:	77 40                	ja     80105170 <sys_fstat+0x60>
80105130:	e8 fb ea ff ff       	call   80103c30 <myproc>
80105135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105138:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010513c:	85 f6                	test   %esi,%esi
8010513e:	74 30                	je     80105170 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	6a 14                	push   $0x14
80105145:	53                   	push   %ebx
80105146:	6a 01                	push   $0x1
80105148:	e8 e3 fa ff ff       	call   80104c30 <argptr>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	78 1c                	js     80105170 <sys_fstat+0x60>
  return filestat(f, st);
80105154:	83 ec 08             	sub    $0x8,%esp
80105157:	ff 75 f4             	push   -0xc(%ebp)
8010515a:	56                   	push   %esi
8010515b:	e8 30 c1 ff ff       	call   80101290 <filestat>
80105160:	83 c4 10             	add    $0x10,%esp
}
80105163:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105166:	5b                   	pop    %ebx
80105167:	5e                   	pop    %esi
80105168:	5d                   	pop    %ebp
80105169:	c3                   	ret    
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105175:	eb ec                	jmp    80105163 <sys_fstat+0x53>
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <sys_link>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105185:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105188:	53                   	push   %ebx
80105189:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010518c:	50                   	push   %eax
8010518d:	6a 00                	push   $0x0
8010518f:	e8 0c fb ff ff       	call   80104ca0 <argstr>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
80105199:	0f 88 fb 00 00 00    	js     8010529a <sys_link+0x11a>
8010519f:	83 ec 08             	sub    $0x8,%esp
801051a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051a5:	50                   	push   %eax
801051a6:	6a 01                	push   $0x1
801051a8:	e8 f3 fa ff ff       	call   80104ca0 <argstr>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	0f 88 e2 00 00 00    	js     8010529a <sys_link+0x11a>
  begin_op();
801051b8:	e8 63 de ff ff       	call   80103020 <begin_op>
  if((ip = namei(old)) == 0){
801051bd:	83 ec 0c             	sub    $0xc,%esp
801051c0:	ff 75 d4             	push   -0x2c(%ebp)
801051c3:	e8 98 d1 ff ff       	call   80102360 <namei>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	89 c3                	mov    %eax,%ebx
801051cd:	85 c0                	test   %eax,%eax
801051cf:	0f 84 e4 00 00 00    	je     801052b9 <sys_link+0x139>
  ilock(ip);
801051d5:	83 ec 0c             	sub    $0xc,%esp
801051d8:	50                   	push   %eax
801051d9:	e8 62 c8 ff ff       	call   80101a40 <ilock>
  if(ip->type == T_DIR){
801051de:	83 c4 10             	add    $0x10,%esp
801051e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051e6:	0f 84 b5 00 00 00    	je     801052a1 <sys_link+0x121>
  iupdate(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051ef:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051f7:	53                   	push   %ebx
801051f8:	e8 93 c7 ff ff       	call   80101990 <iupdate>
  iunlock(ip);
801051fd:	89 1c 24             	mov    %ebx,(%esp)
80105200:	e8 1b c9 ff ff       	call   80101b20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105205:	58                   	pop    %eax
80105206:	5a                   	pop    %edx
80105207:	57                   	push   %edi
80105208:	ff 75 d0             	push   -0x30(%ebp)
8010520b:	e8 70 d1 ff ff       	call   80102380 <nameiparent>
80105210:	83 c4 10             	add    $0x10,%esp
80105213:	89 c6                	mov    %eax,%esi
80105215:	85 c0                	test   %eax,%eax
80105217:	74 5b                	je     80105274 <sys_link+0xf4>
  ilock(dp);
80105219:	83 ec 0c             	sub    $0xc,%esp
8010521c:	50                   	push   %eax
8010521d:	e8 1e c8 ff ff       	call   80101a40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105222:	8b 03                	mov    (%ebx),%eax
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	39 06                	cmp    %eax,(%esi)
80105229:	75 3d                	jne    80105268 <sys_link+0xe8>
8010522b:	83 ec 04             	sub    $0x4,%esp
8010522e:	ff 73 04             	push   0x4(%ebx)
80105231:	57                   	push   %edi
80105232:	56                   	push   %esi
80105233:	e8 68 d0 ff ff       	call   801022a0 <dirlink>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	85 c0                	test   %eax,%eax
8010523d:	78 29                	js     80105268 <sys_link+0xe8>
  iunlockput(dp);
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	56                   	push   %esi
80105243:	e8 88 ca ff ff       	call   80101cd0 <iunlockput>
  iput(ip);
80105248:	89 1c 24             	mov    %ebx,(%esp)
8010524b:	e8 20 c9 ff ff       	call   80101b70 <iput>
  end_op();
80105250:	e8 3b de ff ff       	call   80103090 <end_op>
  return 0;
80105255:	83 c4 10             	add    $0x10,%esp
80105258:	31 c0                	xor    %eax,%eax
}
8010525a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010525d:	5b                   	pop    %ebx
8010525e:	5e                   	pop    %esi
8010525f:	5f                   	pop    %edi
80105260:	5d                   	pop    %ebp
80105261:	c3                   	ret    
80105262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105268:	83 ec 0c             	sub    $0xc,%esp
8010526b:	56                   	push   %esi
8010526c:	e8 5f ca ff ff       	call   80101cd0 <iunlockput>
    goto bad;
80105271:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	53                   	push   %ebx
80105278:	e8 c3 c7 ff ff       	call   80101a40 <ilock>
  ip->nlink--;
8010527d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105282:	89 1c 24             	mov    %ebx,(%esp)
80105285:	e8 06 c7 ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
8010528a:	89 1c 24             	mov    %ebx,(%esp)
8010528d:	e8 3e ca ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105292:	e8 f9 dd ff ff       	call   80103090 <end_op>
  return -1;
80105297:	83 c4 10             	add    $0x10,%esp
8010529a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529f:	eb b9                	jmp    8010525a <sys_link+0xda>
    iunlockput(ip);
801052a1:	83 ec 0c             	sub    $0xc,%esp
801052a4:	53                   	push   %ebx
801052a5:	e8 26 ca ff ff       	call   80101cd0 <iunlockput>
    end_op();
801052aa:	e8 e1 dd ff ff       	call   80103090 <end_op>
    return -1;
801052af:	83 c4 10             	add    $0x10,%esp
801052b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b7:	eb a1                	jmp    8010525a <sys_link+0xda>
    end_op();
801052b9:	e8 d2 dd ff ff       	call   80103090 <end_op>
    return -1;
801052be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c3:	eb 95                	jmp    8010525a <sys_link+0xda>
801052c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_unlink>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	57                   	push   %edi
801052d4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052d5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052d8:	53                   	push   %ebx
801052d9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052dc:	50                   	push   %eax
801052dd:	6a 00                	push   $0x0
801052df:	e8 bc f9 ff ff       	call   80104ca0 <argstr>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	0f 88 7a 01 00 00    	js     80105469 <sys_unlink+0x199>
  begin_op();
801052ef:	e8 2c dd ff ff       	call   80103020 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052f4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052f7:	83 ec 08             	sub    $0x8,%esp
801052fa:	53                   	push   %ebx
801052fb:	ff 75 c0             	push   -0x40(%ebp)
801052fe:	e8 7d d0 ff ff       	call   80102380 <nameiparent>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105309:	85 c0                	test   %eax,%eax
8010530b:	0f 84 62 01 00 00    	je     80105473 <sys_unlink+0x1a3>
  ilock(dp);
80105311:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105314:	83 ec 0c             	sub    $0xc,%esp
80105317:	57                   	push   %edi
80105318:	e8 23 c7 ff ff       	call   80101a40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010531d:	58                   	pop    %eax
8010531e:	5a                   	pop    %edx
8010531f:	68 d4 7b 10 80       	push   $0x80107bd4
80105324:	53                   	push   %ebx
80105325:	e8 56 cc ff ff       	call   80101f80 <namecmp>
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	85 c0                	test   %eax,%eax
8010532f:	0f 84 fb 00 00 00    	je     80105430 <sys_unlink+0x160>
80105335:	83 ec 08             	sub    $0x8,%esp
80105338:	68 d3 7b 10 80       	push   $0x80107bd3
8010533d:	53                   	push   %ebx
8010533e:	e8 3d cc ff ff       	call   80101f80 <namecmp>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	85 c0                	test   %eax,%eax
80105348:	0f 84 e2 00 00 00    	je     80105430 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010534e:	83 ec 04             	sub    $0x4,%esp
80105351:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105354:	50                   	push   %eax
80105355:	53                   	push   %ebx
80105356:	57                   	push   %edi
80105357:	e8 44 cc ff ff       	call   80101fa0 <dirlookup>
8010535c:	83 c4 10             	add    $0x10,%esp
8010535f:	89 c3                	mov    %eax,%ebx
80105361:	85 c0                	test   %eax,%eax
80105363:	0f 84 c7 00 00 00    	je     80105430 <sys_unlink+0x160>
  ilock(ip);
80105369:	83 ec 0c             	sub    $0xc,%esp
8010536c:	50                   	push   %eax
8010536d:	e8 ce c6 ff ff       	call   80101a40 <ilock>
  if(ip->nlink < 1)
80105372:	83 c4 10             	add    $0x10,%esp
80105375:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010537a:	0f 8e 1c 01 00 00    	jle    8010549c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105380:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105385:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105388:	74 66                	je     801053f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010538a:	83 ec 04             	sub    $0x4,%esp
8010538d:	6a 10                	push   $0x10
8010538f:	6a 00                	push   $0x0
80105391:	57                   	push   %edi
80105392:	e8 89 f5 ff ff       	call   80104920 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105397:	6a 10                	push   $0x10
80105399:	ff 75 c4             	push   -0x3c(%ebp)
8010539c:	57                   	push   %edi
8010539d:	ff 75 b4             	push   -0x4c(%ebp)
801053a0:	e8 ab ca ff ff       	call   80101e50 <writei>
801053a5:	83 c4 20             	add    $0x20,%esp
801053a8:	83 f8 10             	cmp    $0x10,%eax
801053ab:	0f 85 de 00 00 00    	jne    8010548f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b6:	0f 84 94 00 00 00    	je     80105450 <sys_unlink+0x180>
  iunlockput(dp);
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	ff 75 b4             	push   -0x4c(%ebp)
801053c2:	e8 09 c9 ff ff       	call   80101cd0 <iunlockput>
  ip->nlink--;
801053c7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053cc:	89 1c 24             	mov    %ebx,(%esp)
801053cf:	e8 bc c5 ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
801053d4:	89 1c 24             	mov    %ebx,(%esp)
801053d7:	e8 f4 c8 ff ff       	call   80101cd0 <iunlockput>
  end_op();
801053dc:	e8 af dc ff ff       	call   80103090 <end_op>
  return 0;
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	31 c0                	xor    %eax,%eax
}
801053e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e9:	5b                   	pop    %ebx
801053ea:	5e                   	pop    %esi
801053eb:	5f                   	pop    %edi
801053ec:	5d                   	pop    %ebp
801053ed:	c3                   	ret    
801053ee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053f4:	76 94                	jbe    8010538a <sys_unlink+0xba>
801053f6:	be 20 00 00 00       	mov    $0x20,%esi
801053fb:	eb 0b                	jmp    80105408 <sys_unlink+0x138>
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
80105400:	83 c6 10             	add    $0x10,%esi
80105403:	3b 73 58             	cmp    0x58(%ebx),%esi
80105406:	73 82                	jae    8010538a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105408:	6a 10                	push   $0x10
8010540a:	56                   	push   %esi
8010540b:	57                   	push   %edi
8010540c:	53                   	push   %ebx
8010540d:	e8 3e c9 ff ff       	call   80101d50 <readi>
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	83 f8 10             	cmp    $0x10,%eax
80105418:	75 68                	jne    80105482 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010541a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010541f:	74 df                	je     80105400 <sys_unlink+0x130>
    iunlockput(ip);
80105421:	83 ec 0c             	sub    $0xc,%esp
80105424:	53                   	push   %ebx
80105425:	e8 a6 c8 ff ff       	call   80101cd0 <iunlockput>
    goto bad;
8010542a:	83 c4 10             	add    $0x10,%esp
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	ff 75 b4             	push   -0x4c(%ebp)
80105436:	e8 95 c8 ff ff       	call   80101cd0 <iunlockput>
  end_op();
8010543b:	e8 50 dc ff ff       	call   80103090 <end_op>
  return -1;
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105448:	eb 9c                	jmp    801053e6 <sys_unlink+0x116>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105450:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105453:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105456:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010545b:	50                   	push   %eax
8010545c:	e8 2f c5 ff ff       	call   80101990 <iupdate>
80105461:	83 c4 10             	add    $0x10,%esp
80105464:	e9 53 ff ff ff       	jmp    801053bc <sys_unlink+0xec>
    return -1;
80105469:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546e:	e9 73 ff ff ff       	jmp    801053e6 <sys_unlink+0x116>
    end_op();
80105473:	e8 18 dc ff ff       	call   80103090 <end_op>
    return -1;
80105478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547d:	e9 64 ff ff ff       	jmp    801053e6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105482:	83 ec 0c             	sub    $0xc,%esp
80105485:	68 f8 7b 10 80       	push   $0x80107bf8
8010548a:	e8 f1 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	68 0a 7c 10 80       	push   $0x80107c0a
80105497:	e8 e4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010549c:	83 ec 0c             	sub    $0xc,%esp
8010549f:	68 e6 7b 10 80       	push   $0x80107be6
801054a4:	e8 d7 ae ff ff       	call   80100380 <panic>
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054b0 <sys_open>:

int
sys_open(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054b8:	53                   	push   %ebx
801054b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054bc:	50                   	push   %eax
801054bd:	6a 00                	push   $0x0
801054bf:	e8 dc f7 ff ff       	call   80104ca0 <argstr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	0f 88 8e 00 00 00    	js     8010555d <sys_open+0xad>
801054cf:	83 ec 08             	sub    $0x8,%esp
801054d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054d5:	50                   	push   %eax
801054d6:	6a 01                	push   $0x1
801054d8:	e8 03 f7 ff ff       	call   80104be0 <argint>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 79                	js     8010555d <sys_open+0xad>
    return -1;

  begin_op();
801054e4:	e8 37 db ff ff       	call   80103020 <begin_op>

  if(omode & O_CREATE){
801054e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054ed:	75 79                	jne    80105568 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	ff 75 e0             	push   -0x20(%ebp)
801054f5:	e8 66 ce ff ff       	call   80102360 <namei>
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	89 c6                	mov    %eax,%esi
801054ff:	85 c0                	test   %eax,%eax
80105501:	0f 84 7e 00 00 00    	je     80105585 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	50                   	push   %eax
8010550b:	e8 30 c5 ff ff       	call   80101a40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105518:	0f 84 c2 00 00 00    	je     801055e0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010551e:	e8 cd bb ff ff       	call   801010f0 <filealloc>
80105523:	89 c7                	mov    %eax,%edi
80105525:	85 c0                	test   %eax,%eax
80105527:	74 23                	je     8010554c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105529:	e8 02 e7 ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010552e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105530:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105534:	85 d2                	test   %edx,%edx
80105536:	74 60                	je     80105598 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105538:	83 c3 01             	add    $0x1,%ebx
8010553b:	83 fb 10             	cmp    $0x10,%ebx
8010553e:	75 f0                	jne    80105530 <sys_open+0x80>
    if(f)
      fileclose(f);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	57                   	push   %edi
80105544:	e8 67 bc ff ff       	call   801011b0 <fileclose>
80105549:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	56                   	push   %esi
80105550:	e8 7b c7 ff ff       	call   80101cd0 <iunlockput>
    end_op();
80105555:	e8 36 db ff ff       	call   80103090 <end_op>
    return -1;
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105562:	eb 6d                	jmp    801055d1 <sys_open+0x121>
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010556e:	31 c9                	xor    %ecx,%ecx
80105570:	ba 02 00 00 00       	mov    $0x2,%edx
80105575:	6a 00                	push   $0x0
80105577:	e8 14 f8 ff ff       	call   80104d90 <create>
    if(ip == 0){
8010557c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010557f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105581:	85 c0                	test   %eax,%eax
80105583:	75 99                	jne    8010551e <sys_open+0x6e>
      end_op();
80105585:	e8 06 db ff ff       	call   80103090 <end_op>
      return -1;
8010558a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010558f:	eb 40                	jmp    801055d1 <sys_open+0x121>
80105591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105598:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010559b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010559f:	56                   	push   %esi
801055a0:	e8 7b c5 ff ff       	call   80101b20 <iunlock>
  end_op();
801055a5:	e8 e6 da ff ff       	call   80103090 <end_op>

  f->type = FD_INODE;
801055aa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055b6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055b9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055bb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055c2:	f7 d0                	not    %eax
801055c4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055c7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055ca:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055cd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d4:	89 d8                	mov    %ebx,%eax
801055d6:	5b                   	pop    %ebx
801055d7:	5e                   	pop    %esi
801055d8:	5f                   	pop    %edi
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055df:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055e3:	85 c9                	test   %ecx,%ecx
801055e5:	0f 84 33 ff ff ff    	je     8010551e <sys_open+0x6e>
801055eb:	e9 5c ff ff ff       	jmp    8010554c <sys_open+0x9c>

801055f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055f6:	e8 25 da ff ff       	call   80103020 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 97 f6 ff ff       	call   80104ca0 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 30                	js     80105640 <sys_mkdir+0x50>
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	31 c9                	xor    %ecx,%ecx
80105618:	ba 01 00 00 00       	mov    $0x1,%edx
8010561d:	6a 00                	push   $0x0
8010561f:	e8 6c f7 ff ff       	call   80104d90 <create>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	74 15                	je     80105640 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	50                   	push   %eax
8010562f:	e8 9c c6 ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105634:	e8 57 da ff ff       	call   80103090 <end_op>
  return 0;
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	31 c0                	xor    %eax,%eax
}
8010563e:	c9                   	leave  
8010563f:	c3                   	ret    
    end_op();
80105640:	e8 4b da ff ff       	call   80103090 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_mknod>:

int
sys_mknod(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105656:	e8 c5 d9 ff ff       	call   80103020 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105661:	50                   	push   %eax
80105662:	6a 00                	push   $0x0
80105664:	e8 37 f6 ff ff       	call   80104ca0 <argstr>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 60                	js     801056d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105676:	50                   	push   %eax
80105677:	6a 01                	push   $0x1
80105679:	e8 62 f5 ff ff       	call   80104be0 <argint>
  if((argstr(0, &path)) < 0 ||
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 4b                	js     801056d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105685:	83 ec 08             	sub    $0x8,%esp
80105688:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568b:	50                   	push   %eax
8010568c:	6a 02                	push   $0x2
8010568e:	e8 4d f5 ff ff       	call   80104be0 <argint>
     argint(1, &major) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 36                	js     801056d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010569a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010569e:	83 ec 0c             	sub    $0xc,%esp
801056a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056a5:	ba 03 00 00 00       	mov    $0x3,%edx
801056aa:	50                   	push   %eax
801056ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ae:	e8 dd f6 ff ff       	call   80104d90 <create>
     argint(2, &minor) < 0 ||
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	74 16                	je     801056d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	50                   	push   %eax
801056be:	e8 0d c6 ff ff       	call   80101cd0 <iunlockput>
  end_op();
801056c3:	e8 c8 d9 ff ff       	call   80103090 <end_op>
  return 0;
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	31 c0                	xor    %eax,%eax
}
801056cd:	c9                   	leave  
801056ce:	c3                   	ret    
801056cf:	90                   	nop
    end_op();
801056d0:	e8 bb d9 ff ff       	call   80103090 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_chdir>:

int
sys_chdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
801056e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056e8:	e8 43 e5 ff ff       	call   80103c30 <myproc>
801056ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ef:	e8 2c d9 ff ff       	call   80103020 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056fa:	50                   	push   %eax
801056fb:	6a 00                	push   $0x0
801056fd:	e8 9e f5 ff ff       	call   80104ca0 <argstr>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 77                	js     80105780 <sys_chdir+0xa0>
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	ff 75 f4             	push   -0xc(%ebp)
8010570f:	e8 4c cc ff ff       	call   80102360 <namei>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	89 c3                	mov    %eax,%ebx
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 63                	je     80105780 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	50                   	push   %eax
80105721:	e8 1a c3 ff ff       	call   80101a40 <ilock>
  if(ip->type != T_DIR){
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572e:	75 30                	jne    80105760 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	53                   	push   %ebx
80105734:	e8 e7 c3 ff ff       	call   80101b20 <iunlock>
  iput(curproc->cwd);
80105739:	58                   	pop    %eax
8010573a:	ff 76 68             	push   0x68(%esi)
8010573d:	e8 2e c4 ff ff       	call   80101b70 <iput>
  end_op();
80105742:	e8 49 d9 ff ff       	call   80103090 <end_op>
  curproc->cwd = ip;
80105747:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	31 c0                	xor    %eax,%eax
}
8010574f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105752:	5b                   	pop    %ebx
80105753:	5e                   	pop    %esi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret    
80105756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 67 c5 ff ff       	call   80101cd0 <iunlockput>
    end_op();
80105769:	e8 22 d9 ff ff       	call   80103090 <end_op>
    return -1;
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105776:	eb d7                	jmp    8010574f <sys_chdir+0x6f>
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
    end_op();
80105780:	e8 0b d9 ff ff       	call   80103090 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578a:	eb c3                	jmp    8010574f <sys_chdir+0x6f>
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_exec>:

int
sys_exec(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105795:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010579b:	53                   	push   %ebx
8010579c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057a2:	50                   	push   %eax
801057a3:	6a 00                	push   $0x0
801057a5:	e8 f6 f4 ff ff       	call   80104ca0 <argstr>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	85 c0                	test   %eax,%eax
801057af:	0f 88 87 00 00 00    	js     8010583c <sys_exec+0xac>
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057be:	50                   	push   %eax
801057bf:	6a 01                	push   $0x1
801057c1:	e8 1a f4 ff ff       	call   80104be0 <argint>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 6f                	js     8010583c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057cd:	83 ec 04             	sub    $0x4,%esp
801057d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057d8:	68 80 00 00 00       	push   $0x80
801057dd:	6a 00                	push   $0x0
801057df:	56                   	push   %esi
801057e0:	e8 3b f1 ff ff       	call   80104920 <memset>
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ef:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105800:	50                   	push   %eax
80105801:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105807:	01 f8                	add    %edi,%eax
80105809:	50                   	push   %eax
8010580a:	e8 41 f3 ff ff       	call   80104b50 <fetchint>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 26                	js     8010583c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105816:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	74 30                	je     80105850 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105826:	52                   	push   %edx
80105827:	50                   	push   %eax
80105828:	e8 63 f3 ff ff       	call   80104b90 <fetchstr>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	85 c0                	test   %eax,%eax
80105832:	78 08                	js     8010583c <sys_exec+0xac>
  for(i=0;; i++){
80105834:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105837:	83 fb 20             	cmp    $0x20,%ebx
8010583a:	75 b4                	jne    801057f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010583c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010583f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105844:	5b                   	pop    %ebx
80105845:	5e                   	pop    %esi
80105846:	5f                   	pop    %edi
80105847:	5d                   	pop    %ebp
80105848:	c3                   	ret    
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105850:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105857:	00 00 00 00 
  return exec(path, argv);
8010585b:	83 ec 08             	sub    $0x8,%esp
8010585e:	56                   	push   %esi
8010585f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105865:	e8 06 b5 ff ff       	call   80100d70 <exec>
8010586a:	83 c4 10             	add    $0x10,%esp
}
8010586d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105870:	5b                   	pop    %ebx
80105871:	5e                   	pop    %esi
80105872:	5f                   	pop    %edi
80105873:	5d                   	pop    %ebp
80105874:	c3                   	ret    
80105875:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_pipe>:

int
sys_pipe(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105885:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105888:	53                   	push   %ebx
80105889:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010588c:	6a 08                	push   $0x8
8010588e:	50                   	push   %eax
8010588f:	6a 00                	push   $0x0
80105891:	e8 9a f3 ff ff       	call   80104c30 <argptr>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	78 4a                	js     801058e7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010589d:	83 ec 08             	sub    $0x8,%esp
801058a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a3:	50                   	push   %eax
801058a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058a7:	50                   	push   %eax
801058a8:	e8 43 de ff ff       	call   801036f0 <pipealloc>
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	85 c0                	test   %eax,%eax
801058b2:	78 33                	js     801058e7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058b7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058b9:	e8 72 e3 ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058be:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058c0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058c4:	85 f6                	test   %esi,%esi
801058c6:	74 28                	je     801058f0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058c8:	83 c3 01             	add    $0x1,%ebx
801058cb:	83 fb 10             	cmp    $0x10,%ebx
801058ce:	75 f0                	jne    801058c0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	ff 75 e0             	push   -0x20(%ebp)
801058d6:	e8 d5 b8 ff ff       	call   801011b0 <fileclose>
    fileclose(wf);
801058db:	58                   	pop    %eax
801058dc:	ff 75 e4             	push   -0x1c(%ebp)
801058df:	e8 cc b8 ff ff       	call   801011b0 <fileclose>
    return -1;
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ec:	eb 53                	jmp    80105941 <sys_pipe+0xc1>
801058ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058f0:	8d 73 08             	lea    0x8(%ebx),%esi
801058f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058fa:	e8 31 e3 ff ff       	call   80103c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ff:	31 d2                	xor    %edx,%edx
80105901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105908:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010590c:	85 c9                	test   %ecx,%ecx
8010590e:	74 20                	je     80105930 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105910:	83 c2 01             	add    $0x1,%edx
80105913:	83 fa 10             	cmp    $0x10,%edx
80105916:	75 f0                	jne    80105908 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105918:	e8 13 e3 ff ff       	call   80103c30 <myproc>
8010591d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105924:	00 
80105925:	eb a9                	jmp    801058d0 <sys_pipe+0x50>
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105930:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105934:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105937:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105939:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010593c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010593f:	31 c0                	xor    %eax,%eax
}
80105941:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105944:	5b                   	pop    %ebx
80105945:	5e                   	pop    %esi
80105946:	5f                   	pop    %edi
80105947:	5d                   	pop    %ebp
80105948:	c3                   	ret    
80105949:	66 90                	xchg   %ax,%ax
8010594b:	66 90                	xchg   %ax,%ax
8010594d:	66 90                	xchg   %ax,%ax
8010594f:	90                   	nop

80105950 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105950:	e9 7b e4 ff ff       	jmp    80103dd0 <fork>
80105955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_exit>:
}

int
sys_exit(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  exit();
80105966:	e8 e5 e6 ff ff       	call   80104050 <exit>
  return 0;  // not reached
}
8010596b:	31 c0                	xor    %eax,%eax
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    
8010596f:	90                   	nop

80105970 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105970:	e9 0b e8 ff ff       	jmp    80104180 <wait>
80105975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_kill>:
}

int
sys_kill(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105989:	50                   	push   %eax
8010598a:	6a 00                	push   $0x0
8010598c:	e8 4f f2 ff ff       	call   80104be0 <argint>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	78 18                	js     801059b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	ff 75 f4             	push   -0xc(%ebp)
8010599e:	e8 7d ea ff ff       	call   80104420 <kill>
801059a3:	83 c4 10             	add    $0x10,%esp
}
801059a6:	c9                   	leave  
801059a7:	c3                   	ret    
801059a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop
801059b0:	c9                   	leave  
    return -1;
801059b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b6:	c3                   	ret    
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_getpid>:

int
sys_getpid(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059c6:	e8 65 e2 ff ff       	call   80103c30 <myproc>
801059cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    

801059d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059da:	50                   	push   %eax
801059db:	6a 00                	push   $0x0
801059dd:	e8 fe f1 ff ff       	call   80104be0 <argint>
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	85 c0                	test   %eax,%eax
801059e7:	78 27                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059e9:	e8 42 e2 ff ff       	call   80103c30 <myproc>
  if(growproc(n) < 0)
801059ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059f3:	ff 75 f4             	push   -0xc(%ebp)
801059f6:	e8 55 e3 ff ff       	call   80103d50 <growproc>
801059fb:	83 c4 10             	add    $0x10,%esp
801059fe:	85 c0                	test   %eax,%eax
80105a00:	78 0e                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a02:	89 d8                	mov    %ebx,%eax
80105a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a07:	c9                   	leave  
80105a08:	c3                   	ret    
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a15:	eb eb                	jmp    80105a02 <sys_sbrk+0x32>
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_sleep>:

int
sys_sleep(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 ae f1 ff ff       	call   80104be0 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	0f 88 8a 00 00 00    	js     80105ac7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 20 3d 11 80       	push   $0x80113d20
80105a45:	e8 16 ee ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a4d:	8b 1d 00 3d 11 80    	mov    0x80113d00,%ebx
  while(ticks - ticks0 < n){
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 d2                	test   %edx,%edx
80105a58:	75 27                	jne    80105a81 <sys_sleep+0x61>
80105a5a:	eb 54                	jmp    80105ab0 <sys_sleep+0x90>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	68 20 3d 11 80       	push   $0x80113d20
80105a68:	68 00 3d 11 80       	push   $0x80113d00
80105a6d:	e8 8e e8 ff ff       	call   80104300 <sleep>
  while(ticks - ticks0 < n){
80105a72:	a1 00 3d 11 80       	mov    0x80113d00,%eax
80105a77:	83 c4 10             	add    $0x10,%esp
80105a7a:	29 d8                	sub    %ebx,%eax
80105a7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a7f:	73 2f                	jae    80105ab0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a81:	e8 aa e1 ff ff       	call   80103c30 <myproc>
80105a86:	8b 40 24             	mov    0x24(%eax),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	74 d3                	je     80105a60 <sys_sleep+0x40>
      release(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 20 3d 11 80       	push   $0x80113d20
80105a95:	e8 66 ed ff ff       	call   80104800 <release>
  }
  release(&tickslock);
  return 0;
}
80105a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	68 20 3d 11 80       	push   $0x80113d20
80105ab8:	e8 43 ed ff ff       	call   80104800 <release>
  return 0;
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	31 c0                	xor    %eax,%eax
}
80105ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
    return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	eb f4                	jmp    80105ac2 <sys_sleep+0xa2>
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	53                   	push   %ebx
80105ad4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ad7:	68 20 3d 11 80       	push   $0x80113d20
80105adc:	e8 7f ed ff ff       	call   80104860 <acquire>
  xticks = ticks;
80105ae1:	8b 1d 00 3d 11 80    	mov    0x80113d00,%ebx
  release(&tickslock);
80105ae7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105aee:	e8 0d ed ff ff       	call   80104800 <release>
  return xticks;
}
80105af3:	89 d8                	mov    %ebx,%eax
80105af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af8:	c9                   	leave  
80105af9:	c3                   	ret    

80105afa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105afa:	1e                   	push   %ds
  pushl %es
80105afb:	06                   	push   %es
  pushl %fs
80105afc:	0f a0                	push   %fs
  pushl %gs
80105afe:	0f a8                	push   %gs
  pushal
80105b00:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b01:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b05:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b07:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b09:	54                   	push   %esp
  call trap
80105b0a:	e8 c1 00 00 00       	call   80105bd0 <trap>
  addl $4, %esp
80105b0f:	83 c4 04             	add    $0x4,%esp

80105b12 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b12:	61                   	popa   
  popl %gs
80105b13:	0f a9                	pop    %gs
  popl %fs
80105b15:	0f a1                	pop    %fs
  popl %es
80105b17:	07                   	pop    %es
  popl %ds
80105b18:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b19:	83 c4 08             	add    $0x8,%esp
  iret
80105b1c:	cf                   	iret   
80105b1d:	66 90                	xchg   %ax,%ax
80105b1f:	90                   	nop

80105b20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b21:	31 c0                	xor    %eax,%eax
{
80105b23:	89 e5                	mov    %esp,%ebp
80105b25:	83 ec 08             	sub    $0x8,%esp
80105b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b30:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b37:	c7 04 c5 62 3d 11 80 	movl   $0x8e000008,-0x7feec29e(,%eax,8)
80105b3e:	08 00 00 8e 
80105b42:	66 89 14 c5 60 3d 11 	mov    %dx,-0x7feec2a0(,%eax,8)
80105b49:	80 
80105b4a:	c1 ea 10             	shr    $0x10,%edx
80105b4d:	66 89 14 c5 66 3d 11 	mov    %dx,-0x7feec29a(,%eax,8)
80105b54:	80 
  for(i = 0; i < 256; i++)
80105b55:	83 c0 01             	add    $0x1,%eax
80105b58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b5d:	75 d1                	jne    80105b30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b62:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b67:	c7 05 62 3f 11 80 08 	movl   $0xef000008,0x80113f62
80105b6e:	00 00 ef 
  initlock(&tickslock, "time");
80105b71:	68 19 7c 10 80       	push   $0x80107c19
80105b76:	68 20 3d 11 80       	push   $0x80113d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b7b:	66 a3 60 3f 11 80    	mov    %ax,0x80113f60
80105b81:	c1 e8 10             	shr    $0x10,%eax
80105b84:	66 a3 66 3f 11 80    	mov    %ax,0x80113f66
  initlock(&tickslock, "time");
80105b8a:	e8 01 eb ff ff       	call   80104690 <initlock>
}
80105b8f:	83 c4 10             	add    $0x10,%esp
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    
80105b94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop

80105ba0 <idtinit>:

void
idtinit(void)
{
80105ba0:	55                   	push   %ebp
  pd[0] = size-1;
80105ba1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ba6:	89 e5                	mov    %esp,%ebp
80105ba8:	83 ec 10             	sub    $0x10,%esp
80105bab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105baf:	b8 60 3d 11 80       	mov    $0x80113d60,%eax
80105bb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bb8:	c1 e8 10             	shr    $0x10,%eax
80105bbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bc5:	c9                   	leave  
80105bc6:	c3                   	ret    
80105bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
80105bd6:	83 ec 1c             	sub    $0x1c,%esp
80105bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105bdc:	8b 43 30             	mov    0x30(%ebx),%eax
80105bdf:	83 f8 40             	cmp    $0x40,%eax
80105be2:	0f 84 68 01 00 00    	je     80105d50 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105be8:	83 e8 20             	sub    $0x20,%eax
80105beb:	83 f8 1f             	cmp    $0x1f,%eax
80105bee:	0f 87 8c 00 00 00    	ja     80105c80 <trap+0xb0>
80105bf4:	ff 24 85 c0 7c 10 80 	jmp    *-0x7fef8340(,%eax,4)
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c00:	e8 fb c8 ff ff       	call   80102500 <ideintr>
    lapiceoi();
80105c05:	e8 c6 cf ff ff       	call   80102bd0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c0a:	e8 21 e0 ff ff       	call   80103c30 <myproc>
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	74 1d                	je     80105c30 <trap+0x60>
80105c13:	e8 18 e0 ff ff       	call   80103c30 <myproc>
80105c18:	8b 50 24             	mov    0x24(%eax),%edx
80105c1b:	85 d2                	test   %edx,%edx
80105c1d:	74 11                	je     80105c30 <trap+0x60>
80105c1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c23:	83 e0 03             	and    $0x3,%eax
80105c26:	66 83 f8 03          	cmp    $0x3,%ax
80105c2a:	0f 84 e8 01 00 00    	je     80105e18 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c30:	e8 fb df ff ff       	call   80103c30 <myproc>
80105c35:	85 c0                	test   %eax,%eax
80105c37:	74 0f                	je     80105c48 <trap+0x78>
80105c39:	e8 f2 df ff ff       	call   80103c30 <myproc>
80105c3e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c42:	0f 84 b8 00 00 00    	je     80105d00 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c48:	e8 e3 df ff ff       	call   80103c30 <myproc>
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	74 1d                	je     80105c6e <trap+0x9e>
80105c51:	e8 da df ff ff       	call   80103c30 <myproc>
80105c56:	8b 40 24             	mov    0x24(%eax),%eax
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	74 11                	je     80105c6e <trap+0x9e>
80105c5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c61:	83 e0 03             	and    $0x3,%eax
80105c64:	66 83 f8 03          	cmp    $0x3,%ax
80105c68:	0f 84 0f 01 00 00    	je     80105d7d <trap+0x1ad>
    exit();
}
80105c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c71:	5b                   	pop    %ebx
80105c72:	5e                   	pop    %esi
80105c73:	5f                   	pop    %edi
80105c74:	5d                   	pop    %ebp
80105c75:	c3                   	ret    
80105c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c80:	e8 ab df ff ff       	call   80103c30 <myproc>
80105c85:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c88:	85 c0                	test   %eax,%eax
80105c8a:	0f 84 a2 01 00 00    	je     80105e32 <trap+0x262>
80105c90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c94:	0f 84 98 01 00 00    	je     80105e32 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c9a:	0f 20 d1             	mov    %cr2,%ecx
80105c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ca0:	e8 6b df ff ff       	call   80103c10 <cpuid>
80105ca5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ca8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cab:	8b 43 34             	mov    0x34(%ebx),%eax
80105cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105cb1:	e8 7a df ff ff       	call   80103c30 <myproc>
80105cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cb9:	e8 72 df ff ff       	call   80103c30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cc4:	51                   	push   %ecx
80105cc5:	57                   	push   %edi
80105cc6:	52                   	push   %edx
80105cc7:	ff 75 e4             	push   -0x1c(%ebp)
80105cca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ccb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105cce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cd1:	56                   	push   %esi
80105cd2:	ff 70 10             	push   0x10(%eax)
80105cd5:	68 7c 7c 10 80       	push   $0x80107c7c
80105cda:	e8 c1 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105cdf:	83 c4 20             	add    $0x20,%esp
80105ce2:	e8 49 df ff ff       	call   80103c30 <myproc>
80105ce7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cee:	e8 3d df ff ff       	call   80103c30 <myproc>
80105cf3:	85 c0                	test   %eax,%eax
80105cf5:	0f 85 18 ff ff ff    	jne    80105c13 <trap+0x43>
80105cfb:	e9 30 ff ff ff       	jmp    80105c30 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105d00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d04:	0f 85 3e ff ff ff    	jne    80105c48 <trap+0x78>
    yield();
80105d0a:	e8 a1 e5 ff ff       	call   801042b0 <yield>
80105d0f:	e9 34 ff ff ff       	jmp    80105c48 <trap+0x78>
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d1f:	e8 ec de ff ff       	call   80103c10 <cpuid>
80105d24:	57                   	push   %edi
80105d25:	56                   	push   %esi
80105d26:	50                   	push   %eax
80105d27:	68 24 7c 10 80       	push   $0x80107c24
80105d2c:	e8 6f a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105d31:	e8 9a ce ff ff       	call   80102bd0 <lapiceoi>
    break;
80105d36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d39:	e8 f2 de ff ff       	call   80103c30 <myproc>
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	0f 85 cd fe ff ff    	jne    80105c13 <trap+0x43>
80105d46:	e9 e5 fe ff ff       	jmp    80105c30 <trap+0x60>
80105d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop
    if(myproc()->killed)
80105d50:	e8 db de ff ff       	call   80103c30 <myproc>
80105d55:	8b 70 24             	mov    0x24(%eax),%esi
80105d58:	85 f6                	test   %esi,%esi
80105d5a:	0f 85 c8 00 00 00    	jne    80105e28 <trap+0x258>
    myproc()->tf = tf;
80105d60:	e8 cb de ff ff       	call   80103c30 <myproc>
80105d65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d68:	e8 b3 ef ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80105d6d:	e8 be de ff ff       	call   80103c30 <myproc>
80105d72:	8b 48 24             	mov    0x24(%eax),%ecx
80105d75:	85 c9                	test   %ecx,%ecx
80105d77:	0f 84 f1 fe ff ff    	je     80105c6e <trap+0x9e>
}
80105d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d80:	5b                   	pop    %ebx
80105d81:	5e                   	pop    %esi
80105d82:	5f                   	pop    %edi
80105d83:	5d                   	pop    %ebp
      exit();
80105d84:	e9 c7 e2 ff ff       	jmp    80104050 <exit>
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d90:	e8 3b 02 00 00       	call   80105fd0 <uartintr>
    lapiceoi();
80105d95:	e8 36 ce ff ff       	call   80102bd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d9a:	e8 91 de ff ff       	call   80103c30 <myproc>
80105d9f:	85 c0                	test   %eax,%eax
80105da1:	0f 85 6c fe ff ff    	jne    80105c13 <trap+0x43>
80105da7:	e9 84 fe ff ff       	jmp    80105c30 <trap+0x60>
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105db0:	e8 db cc ff ff       	call   80102a90 <kbdintr>
    lapiceoi();
80105db5:	e8 16 ce ff ff       	call   80102bd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dba:	e8 71 de ff ff       	call   80103c30 <myproc>
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	0f 85 4c fe ff ff    	jne    80105c13 <trap+0x43>
80105dc7:	e9 64 fe ff ff       	jmp    80105c30 <trap+0x60>
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105dd0:	e8 3b de ff ff       	call   80103c10 <cpuid>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 85 28 fe ff ff    	jne    80105c05 <trap+0x35>
      acquire(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 20 3d 11 80       	push   $0x80113d20
80105de5:	e8 76 ea ff ff       	call   80104860 <acquire>
      wakeup(&ticks);
80105dea:	c7 04 24 00 3d 11 80 	movl   $0x80113d00,(%esp)
      ticks++;
80105df1:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
      wakeup(&ticks);
80105df8:	e8 c3 e5 ff ff       	call   801043c0 <wakeup>
      release(&tickslock);
80105dfd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105e04:	e8 f7 e9 ff ff       	call   80104800 <release>
80105e09:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e0c:	e9 f4 fd ff ff       	jmp    80105c05 <trap+0x35>
80105e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e18:	e8 33 e2 ff ff       	call   80104050 <exit>
80105e1d:	e9 0e fe ff ff       	jmp    80105c30 <trap+0x60>
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e28:	e8 23 e2 ff ff       	call   80104050 <exit>
80105e2d:	e9 2e ff ff ff       	jmp    80105d60 <trap+0x190>
80105e32:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e35:	e8 d6 dd ff ff       	call   80103c10 <cpuid>
80105e3a:	83 ec 0c             	sub    $0xc,%esp
80105e3d:	56                   	push   %esi
80105e3e:	57                   	push   %edi
80105e3f:	50                   	push   %eax
80105e40:	ff 73 30             	push   0x30(%ebx)
80105e43:	68 48 7c 10 80       	push   $0x80107c48
80105e48:	e8 53 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105e4d:	83 c4 14             	add    $0x14,%esp
80105e50:	68 1e 7c 10 80       	push   $0x80107c1e
80105e55:	e8 26 a5 ff ff       	call   80100380 <panic>
80105e5a:	66 90                	xchg   %ax,%ax
80105e5c:	66 90                	xchg   %ax,%ax
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e60:	a1 60 45 11 80       	mov    0x80114560,%eax
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 17                	je     80105e80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e6f:	a8 01                	test   $0x1,%al
80105e71:	74 0d                	je     80105e80 <uartgetc+0x20>
80105e73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e79:	0f b6 c0             	movzbl %al,%eax
80105e7c:	c3                   	ret    
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e85:	c3                   	ret    
80105e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi

80105e90 <uartinit>:
{
80105e90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e91:	31 c9                	xor    %ecx,%ecx
80105e93:	89 c8                	mov    %ecx,%eax
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	57                   	push   %edi
80105e98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e9d:	56                   	push   %esi
80105e9e:	89 fa                	mov    %edi,%edx
80105ea0:	53                   	push   %ebx
80105ea1:	83 ec 1c             	sub    $0x1c,%esp
80105ea4:	ee                   	out    %al,(%dx)
80105ea5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105eaa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eaf:	89 f2                	mov    %esi,%edx
80105eb1:	ee                   	out    %al,(%dx)
80105eb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105eb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebc:	ee                   	out    %al,(%dx)
80105ebd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105ec2:	89 c8                	mov    %ecx,%eax
80105ec4:	89 da                	mov    %ebx,%edx
80105ec6:	ee                   	out    %al,(%dx)
80105ec7:	b8 03 00 00 00       	mov    $0x3,%eax
80105ecc:	89 f2                	mov    %esi,%edx
80105ece:	ee                   	out    %al,(%dx)
80105ecf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ed4:	89 c8                	mov    %ecx,%eax
80105ed6:	ee                   	out    %al,(%dx)
80105ed7:	b8 01 00 00 00       	mov    $0x1,%eax
80105edc:	89 da                	mov    %ebx,%edx
80105ede:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105edf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ee4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ee5:	3c ff                	cmp    $0xff,%al
80105ee7:	74 78                	je     80105f61 <uartinit+0xd1>
  uart = 1;
80105ee9:	c7 05 60 45 11 80 01 	movl   $0x1,0x80114560
80105ef0:	00 00 00 
80105ef3:	89 fa                	mov    %edi,%edx
80105ef5:	ec                   	in     (%dx),%al
80105ef6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105efb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105efc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105eff:	bf 40 7d 10 80       	mov    $0x80107d40,%edi
80105f04:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f09:	6a 00                	push   $0x0
80105f0b:	6a 04                	push   $0x4
80105f0d:	e8 2e c8 ff ff       	call   80102740 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f12:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105f20:	a1 60 45 11 80       	mov    0x80114560,%eax
80105f25:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f2a:	85 c0                	test   %eax,%eax
80105f2c:	75 14                	jne    80105f42 <uartinit+0xb2>
80105f2e:	eb 23                	jmp    80105f53 <uartinit+0xc3>
    microdelay(10);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	6a 0a                	push   $0xa
80105f35:	e8 b6 cc ff ff       	call   80102bf0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	83 eb 01             	sub    $0x1,%ebx
80105f40:	74 07                	je     80105f49 <uartinit+0xb9>
80105f42:	89 f2                	mov    %esi,%edx
80105f44:	ec                   	in     (%dx),%al
80105f45:	a8 20                	test   $0x20,%al
80105f47:	74 e7                	je     80105f30 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f49:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f4d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f52:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f53:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f57:	83 c7 01             	add    $0x1,%edi
80105f5a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f5d:	84 c0                	test   %al,%al
80105f5f:	75 bf                	jne    80105f20 <uartinit+0x90>
}
80105f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f64:	5b                   	pop    %ebx
80105f65:	5e                   	pop    %esi
80105f66:	5f                   	pop    %edi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartputc>:
  if(!uart)
80105f70:	a1 60 45 11 80       	mov    0x80114560,%eax
80105f75:	85 c0                	test   %eax,%eax
80105f77:	74 47                	je     80105fc0 <uartputc+0x50>
{
80105f79:	55                   	push   %ebp
80105f7a:	89 e5                	mov    %esp,%ebp
80105f7c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f82:	53                   	push   %ebx
80105f83:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f88:	eb 18                	jmp    80105fa2 <uartputc+0x32>
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	6a 0a                	push   $0xa
80105f95:	e8 56 cc ff ff       	call   80102bf0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	83 eb 01             	sub    $0x1,%ebx
80105fa0:	74 07                	je     80105fa9 <uartputc+0x39>
80105fa2:	89 f2                	mov    %esi,%edx
80105fa4:	ec                   	in     (%dx),%al
80105fa5:	a8 20                	test   $0x20,%al
80105fa7:	74 e7                	je     80105f90 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80105fac:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fb1:	ee                   	out    %al,(%dx)
}
80105fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5e                   	pop    %esi
80105fb7:	5d                   	pop    %ebp
80105fb8:	c3                   	ret    
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fc0:	c3                   	ret    
80105fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcf:	90                   	nop

80105fd0 <uartintr>:

void
uartintr(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fd6:	68 60 5e 10 80       	push   $0x80105e60
80105fdb:	e8 a0 a8 ff ff       	call   80100880 <consoleintr>
}
80105fe0:	83 c4 10             	add    $0x10,%esp
80105fe3:	c9                   	leave  
80105fe4:	c3                   	ret    

80105fe5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fe5:	6a 00                	push   $0x0
  pushl $0
80105fe7:	6a 00                	push   $0x0
  jmp alltraps
80105fe9:	e9 0c fb ff ff       	jmp    80105afa <alltraps>

80105fee <vector1>:
.globl vector1
vector1:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $1
80105ff0:	6a 01                	push   $0x1
  jmp alltraps
80105ff2:	e9 03 fb ff ff       	jmp    80105afa <alltraps>

80105ff7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $2
80105ff9:	6a 02                	push   $0x2
  jmp alltraps
80105ffb:	e9 fa fa ff ff       	jmp    80105afa <alltraps>

80106000 <vector3>:
.globl vector3
vector3:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $3
80106002:	6a 03                	push   $0x3
  jmp alltraps
80106004:	e9 f1 fa ff ff       	jmp    80105afa <alltraps>

80106009 <vector4>:
.globl vector4
vector4:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $4
8010600b:	6a 04                	push   $0x4
  jmp alltraps
8010600d:	e9 e8 fa ff ff       	jmp    80105afa <alltraps>

80106012 <vector5>:
.globl vector5
vector5:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $5
80106014:	6a 05                	push   $0x5
  jmp alltraps
80106016:	e9 df fa ff ff       	jmp    80105afa <alltraps>

8010601b <vector6>:
.globl vector6
vector6:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $6
8010601d:	6a 06                	push   $0x6
  jmp alltraps
8010601f:	e9 d6 fa ff ff       	jmp    80105afa <alltraps>

80106024 <vector7>:
.globl vector7
vector7:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $7
80106026:	6a 07                	push   $0x7
  jmp alltraps
80106028:	e9 cd fa ff ff       	jmp    80105afa <alltraps>

8010602d <vector8>:
.globl vector8
vector8:
  pushl $8
8010602d:	6a 08                	push   $0x8
  jmp alltraps
8010602f:	e9 c6 fa ff ff       	jmp    80105afa <alltraps>

80106034 <vector9>:
.globl vector9
vector9:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $9
80106036:	6a 09                	push   $0x9
  jmp alltraps
80106038:	e9 bd fa ff ff       	jmp    80105afa <alltraps>

8010603d <vector10>:
.globl vector10
vector10:
  pushl $10
8010603d:	6a 0a                	push   $0xa
  jmp alltraps
8010603f:	e9 b6 fa ff ff       	jmp    80105afa <alltraps>

80106044 <vector11>:
.globl vector11
vector11:
  pushl $11
80106044:	6a 0b                	push   $0xb
  jmp alltraps
80106046:	e9 af fa ff ff       	jmp    80105afa <alltraps>

8010604b <vector12>:
.globl vector12
vector12:
  pushl $12
8010604b:	6a 0c                	push   $0xc
  jmp alltraps
8010604d:	e9 a8 fa ff ff       	jmp    80105afa <alltraps>

80106052 <vector13>:
.globl vector13
vector13:
  pushl $13
80106052:	6a 0d                	push   $0xd
  jmp alltraps
80106054:	e9 a1 fa ff ff       	jmp    80105afa <alltraps>

80106059 <vector14>:
.globl vector14
vector14:
  pushl $14
80106059:	6a 0e                	push   $0xe
  jmp alltraps
8010605b:	e9 9a fa ff ff       	jmp    80105afa <alltraps>

80106060 <vector15>:
.globl vector15
vector15:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $15
80106062:	6a 0f                	push   $0xf
  jmp alltraps
80106064:	e9 91 fa ff ff       	jmp    80105afa <alltraps>

80106069 <vector16>:
.globl vector16
vector16:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $16
8010606b:	6a 10                	push   $0x10
  jmp alltraps
8010606d:	e9 88 fa ff ff       	jmp    80105afa <alltraps>

80106072 <vector17>:
.globl vector17
vector17:
  pushl $17
80106072:	6a 11                	push   $0x11
  jmp alltraps
80106074:	e9 81 fa ff ff       	jmp    80105afa <alltraps>

80106079 <vector18>:
.globl vector18
vector18:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $18
8010607b:	6a 12                	push   $0x12
  jmp alltraps
8010607d:	e9 78 fa ff ff       	jmp    80105afa <alltraps>

80106082 <vector19>:
.globl vector19
vector19:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $19
80106084:	6a 13                	push   $0x13
  jmp alltraps
80106086:	e9 6f fa ff ff       	jmp    80105afa <alltraps>

8010608b <vector20>:
.globl vector20
vector20:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $20
8010608d:	6a 14                	push   $0x14
  jmp alltraps
8010608f:	e9 66 fa ff ff       	jmp    80105afa <alltraps>

80106094 <vector21>:
.globl vector21
vector21:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $21
80106096:	6a 15                	push   $0x15
  jmp alltraps
80106098:	e9 5d fa ff ff       	jmp    80105afa <alltraps>

8010609d <vector22>:
.globl vector22
vector22:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $22
8010609f:	6a 16                	push   $0x16
  jmp alltraps
801060a1:	e9 54 fa ff ff       	jmp    80105afa <alltraps>

801060a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $23
801060a8:	6a 17                	push   $0x17
  jmp alltraps
801060aa:	e9 4b fa ff ff       	jmp    80105afa <alltraps>

801060af <vector24>:
.globl vector24
vector24:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $24
801060b1:	6a 18                	push   $0x18
  jmp alltraps
801060b3:	e9 42 fa ff ff       	jmp    80105afa <alltraps>

801060b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $25
801060ba:	6a 19                	push   $0x19
  jmp alltraps
801060bc:	e9 39 fa ff ff       	jmp    80105afa <alltraps>

801060c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $26
801060c3:	6a 1a                	push   $0x1a
  jmp alltraps
801060c5:	e9 30 fa ff ff       	jmp    80105afa <alltraps>

801060ca <vector27>:
.globl vector27
vector27:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $27
801060cc:	6a 1b                	push   $0x1b
  jmp alltraps
801060ce:	e9 27 fa ff ff       	jmp    80105afa <alltraps>

801060d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $28
801060d5:	6a 1c                	push   $0x1c
  jmp alltraps
801060d7:	e9 1e fa ff ff       	jmp    80105afa <alltraps>

801060dc <vector29>:
.globl vector29
vector29:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $29
801060de:	6a 1d                	push   $0x1d
  jmp alltraps
801060e0:	e9 15 fa ff ff       	jmp    80105afa <alltraps>

801060e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $30
801060e7:	6a 1e                	push   $0x1e
  jmp alltraps
801060e9:	e9 0c fa ff ff       	jmp    80105afa <alltraps>

801060ee <vector31>:
.globl vector31
vector31:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $31
801060f0:	6a 1f                	push   $0x1f
  jmp alltraps
801060f2:	e9 03 fa ff ff       	jmp    80105afa <alltraps>

801060f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $32
801060f9:	6a 20                	push   $0x20
  jmp alltraps
801060fb:	e9 fa f9 ff ff       	jmp    80105afa <alltraps>

80106100 <vector33>:
.globl vector33
vector33:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $33
80106102:	6a 21                	push   $0x21
  jmp alltraps
80106104:	e9 f1 f9 ff ff       	jmp    80105afa <alltraps>

80106109 <vector34>:
.globl vector34
vector34:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $34
8010610b:	6a 22                	push   $0x22
  jmp alltraps
8010610d:	e9 e8 f9 ff ff       	jmp    80105afa <alltraps>

80106112 <vector35>:
.globl vector35
vector35:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $35
80106114:	6a 23                	push   $0x23
  jmp alltraps
80106116:	e9 df f9 ff ff       	jmp    80105afa <alltraps>

8010611b <vector36>:
.globl vector36
vector36:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $36
8010611d:	6a 24                	push   $0x24
  jmp alltraps
8010611f:	e9 d6 f9 ff ff       	jmp    80105afa <alltraps>

80106124 <vector37>:
.globl vector37
vector37:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $37
80106126:	6a 25                	push   $0x25
  jmp alltraps
80106128:	e9 cd f9 ff ff       	jmp    80105afa <alltraps>

8010612d <vector38>:
.globl vector38
vector38:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $38
8010612f:	6a 26                	push   $0x26
  jmp alltraps
80106131:	e9 c4 f9 ff ff       	jmp    80105afa <alltraps>

80106136 <vector39>:
.globl vector39
vector39:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $39
80106138:	6a 27                	push   $0x27
  jmp alltraps
8010613a:	e9 bb f9 ff ff       	jmp    80105afa <alltraps>

8010613f <vector40>:
.globl vector40
vector40:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $40
80106141:	6a 28                	push   $0x28
  jmp alltraps
80106143:	e9 b2 f9 ff ff       	jmp    80105afa <alltraps>

80106148 <vector41>:
.globl vector41
vector41:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $41
8010614a:	6a 29                	push   $0x29
  jmp alltraps
8010614c:	e9 a9 f9 ff ff       	jmp    80105afa <alltraps>

80106151 <vector42>:
.globl vector42
vector42:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $42
80106153:	6a 2a                	push   $0x2a
  jmp alltraps
80106155:	e9 a0 f9 ff ff       	jmp    80105afa <alltraps>

8010615a <vector43>:
.globl vector43
vector43:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $43
8010615c:	6a 2b                	push   $0x2b
  jmp alltraps
8010615e:	e9 97 f9 ff ff       	jmp    80105afa <alltraps>

80106163 <vector44>:
.globl vector44
vector44:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $44
80106165:	6a 2c                	push   $0x2c
  jmp alltraps
80106167:	e9 8e f9 ff ff       	jmp    80105afa <alltraps>

8010616c <vector45>:
.globl vector45
vector45:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $45
8010616e:	6a 2d                	push   $0x2d
  jmp alltraps
80106170:	e9 85 f9 ff ff       	jmp    80105afa <alltraps>

80106175 <vector46>:
.globl vector46
vector46:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $46
80106177:	6a 2e                	push   $0x2e
  jmp alltraps
80106179:	e9 7c f9 ff ff       	jmp    80105afa <alltraps>

8010617e <vector47>:
.globl vector47
vector47:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $47
80106180:	6a 2f                	push   $0x2f
  jmp alltraps
80106182:	e9 73 f9 ff ff       	jmp    80105afa <alltraps>

80106187 <vector48>:
.globl vector48
vector48:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $48
80106189:	6a 30                	push   $0x30
  jmp alltraps
8010618b:	e9 6a f9 ff ff       	jmp    80105afa <alltraps>

80106190 <vector49>:
.globl vector49
vector49:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $49
80106192:	6a 31                	push   $0x31
  jmp alltraps
80106194:	e9 61 f9 ff ff       	jmp    80105afa <alltraps>

80106199 <vector50>:
.globl vector50
vector50:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $50
8010619b:	6a 32                	push   $0x32
  jmp alltraps
8010619d:	e9 58 f9 ff ff       	jmp    80105afa <alltraps>

801061a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $51
801061a4:	6a 33                	push   $0x33
  jmp alltraps
801061a6:	e9 4f f9 ff ff       	jmp    80105afa <alltraps>

801061ab <vector52>:
.globl vector52
vector52:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $52
801061ad:	6a 34                	push   $0x34
  jmp alltraps
801061af:	e9 46 f9 ff ff       	jmp    80105afa <alltraps>

801061b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $53
801061b6:	6a 35                	push   $0x35
  jmp alltraps
801061b8:	e9 3d f9 ff ff       	jmp    80105afa <alltraps>

801061bd <vector54>:
.globl vector54
vector54:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $54
801061bf:	6a 36                	push   $0x36
  jmp alltraps
801061c1:	e9 34 f9 ff ff       	jmp    80105afa <alltraps>

801061c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $55
801061c8:	6a 37                	push   $0x37
  jmp alltraps
801061ca:	e9 2b f9 ff ff       	jmp    80105afa <alltraps>

801061cf <vector56>:
.globl vector56
vector56:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $56
801061d1:	6a 38                	push   $0x38
  jmp alltraps
801061d3:	e9 22 f9 ff ff       	jmp    80105afa <alltraps>

801061d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $57
801061da:	6a 39                	push   $0x39
  jmp alltraps
801061dc:	e9 19 f9 ff ff       	jmp    80105afa <alltraps>

801061e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $58
801061e3:	6a 3a                	push   $0x3a
  jmp alltraps
801061e5:	e9 10 f9 ff ff       	jmp    80105afa <alltraps>

801061ea <vector59>:
.globl vector59
vector59:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $59
801061ec:	6a 3b                	push   $0x3b
  jmp alltraps
801061ee:	e9 07 f9 ff ff       	jmp    80105afa <alltraps>

801061f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $60
801061f5:	6a 3c                	push   $0x3c
  jmp alltraps
801061f7:	e9 fe f8 ff ff       	jmp    80105afa <alltraps>

801061fc <vector61>:
.globl vector61
vector61:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $61
801061fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106200:	e9 f5 f8 ff ff       	jmp    80105afa <alltraps>

80106205 <vector62>:
.globl vector62
vector62:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $62
80106207:	6a 3e                	push   $0x3e
  jmp alltraps
80106209:	e9 ec f8 ff ff       	jmp    80105afa <alltraps>

8010620e <vector63>:
.globl vector63
vector63:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $63
80106210:	6a 3f                	push   $0x3f
  jmp alltraps
80106212:	e9 e3 f8 ff ff       	jmp    80105afa <alltraps>

80106217 <vector64>:
.globl vector64
vector64:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $64
80106219:	6a 40                	push   $0x40
  jmp alltraps
8010621b:	e9 da f8 ff ff       	jmp    80105afa <alltraps>

80106220 <vector65>:
.globl vector65
vector65:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $65
80106222:	6a 41                	push   $0x41
  jmp alltraps
80106224:	e9 d1 f8 ff ff       	jmp    80105afa <alltraps>

80106229 <vector66>:
.globl vector66
vector66:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $66
8010622b:	6a 42                	push   $0x42
  jmp alltraps
8010622d:	e9 c8 f8 ff ff       	jmp    80105afa <alltraps>

80106232 <vector67>:
.globl vector67
vector67:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $67
80106234:	6a 43                	push   $0x43
  jmp alltraps
80106236:	e9 bf f8 ff ff       	jmp    80105afa <alltraps>

8010623b <vector68>:
.globl vector68
vector68:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $68
8010623d:	6a 44                	push   $0x44
  jmp alltraps
8010623f:	e9 b6 f8 ff ff       	jmp    80105afa <alltraps>

80106244 <vector69>:
.globl vector69
vector69:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $69
80106246:	6a 45                	push   $0x45
  jmp alltraps
80106248:	e9 ad f8 ff ff       	jmp    80105afa <alltraps>

8010624d <vector70>:
.globl vector70
vector70:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $70
8010624f:	6a 46                	push   $0x46
  jmp alltraps
80106251:	e9 a4 f8 ff ff       	jmp    80105afa <alltraps>

80106256 <vector71>:
.globl vector71
vector71:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $71
80106258:	6a 47                	push   $0x47
  jmp alltraps
8010625a:	e9 9b f8 ff ff       	jmp    80105afa <alltraps>

8010625f <vector72>:
.globl vector72
vector72:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $72
80106261:	6a 48                	push   $0x48
  jmp alltraps
80106263:	e9 92 f8 ff ff       	jmp    80105afa <alltraps>

80106268 <vector73>:
.globl vector73
vector73:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $73
8010626a:	6a 49                	push   $0x49
  jmp alltraps
8010626c:	e9 89 f8 ff ff       	jmp    80105afa <alltraps>

80106271 <vector74>:
.globl vector74
vector74:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $74
80106273:	6a 4a                	push   $0x4a
  jmp alltraps
80106275:	e9 80 f8 ff ff       	jmp    80105afa <alltraps>

8010627a <vector75>:
.globl vector75
vector75:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $75
8010627c:	6a 4b                	push   $0x4b
  jmp alltraps
8010627e:	e9 77 f8 ff ff       	jmp    80105afa <alltraps>

80106283 <vector76>:
.globl vector76
vector76:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $76
80106285:	6a 4c                	push   $0x4c
  jmp alltraps
80106287:	e9 6e f8 ff ff       	jmp    80105afa <alltraps>

8010628c <vector77>:
.globl vector77
vector77:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $77
8010628e:	6a 4d                	push   $0x4d
  jmp alltraps
80106290:	e9 65 f8 ff ff       	jmp    80105afa <alltraps>

80106295 <vector78>:
.globl vector78
vector78:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $78
80106297:	6a 4e                	push   $0x4e
  jmp alltraps
80106299:	e9 5c f8 ff ff       	jmp    80105afa <alltraps>

8010629e <vector79>:
.globl vector79
vector79:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $79
801062a0:	6a 4f                	push   $0x4f
  jmp alltraps
801062a2:	e9 53 f8 ff ff       	jmp    80105afa <alltraps>

801062a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $80
801062a9:	6a 50                	push   $0x50
  jmp alltraps
801062ab:	e9 4a f8 ff ff       	jmp    80105afa <alltraps>

801062b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $81
801062b2:	6a 51                	push   $0x51
  jmp alltraps
801062b4:	e9 41 f8 ff ff       	jmp    80105afa <alltraps>

801062b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $82
801062bb:	6a 52                	push   $0x52
  jmp alltraps
801062bd:	e9 38 f8 ff ff       	jmp    80105afa <alltraps>

801062c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $83
801062c4:	6a 53                	push   $0x53
  jmp alltraps
801062c6:	e9 2f f8 ff ff       	jmp    80105afa <alltraps>

801062cb <vector84>:
.globl vector84
vector84:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $84
801062cd:	6a 54                	push   $0x54
  jmp alltraps
801062cf:	e9 26 f8 ff ff       	jmp    80105afa <alltraps>

801062d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $85
801062d6:	6a 55                	push   $0x55
  jmp alltraps
801062d8:	e9 1d f8 ff ff       	jmp    80105afa <alltraps>

801062dd <vector86>:
.globl vector86
vector86:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $86
801062df:	6a 56                	push   $0x56
  jmp alltraps
801062e1:	e9 14 f8 ff ff       	jmp    80105afa <alltraps>

801062e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $87
801062e8:	6a 57                	push   $0x57
  jmp alltraps
801062ea:	e9 0b f8 ff ff       	jmp    80105afa <alltraps>

801062ef <vector88>:
.globl vector88
vector88:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $88
801062f1:	6a 58                	push   $0x58
  jmp alltraps
801062f3:	e9 02 f8 ff ff       	jmp    80105afa <alltraps>

801062f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $89
801062fa:	6a 59                	push   $0x59
  jmp alltraps
801062fc:	e9 f9 f7 ff ff       	jmp    80105afa <alltraps>

80106301 <vector90>:
.globl vector90
vector90:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $90
80106303:	6a 5a                	push   $0x5a
  jmp alltraps
80106305:	e9 f0 f7 ff ff       	jmp    80105afa <alltraps>

8010630a <vector91>:
.globl vector91
vector91:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $91
8010630c:	6a 5b                	push   $0x5b
  jmp alltraps
8010630e:	e9 e7 f7 ff ff       	jmp    80105afa <alltraps>

80106313 <vector92>:
.globl vector92
vector92:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $92
80106315:	6a 5c                	push   $0x5c
  jmp alltraps
80106317:	e9 de f7 ff ff       	jmp    80105afa <alltraps>

8010631c <vector93>:
.globl vector93
vector93:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $93
8010631e:	6a 5d                	push   $0x5d
  jmp alltraps
80106320:	e9 d5 f7 ff ff       	jmp    80105afa <alltraps>

80106325 <vector94>:
.globl vector94
vector94:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $94
80106327:	6a 5e                	push   $0x5e
  jmp alltraps
80106329:	e9 cc f7 ff ff       	jmp    80105afa <alltraps>

8010632e <vector95>:
.globl vector95
vector95:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $95
80106330:	6a 5f                	push   $0x5f
  jmp alltraps
80106332:	e9 c3 f7 ff ff       	jmp    80105afa <alltraps>

80106337 <vector96>:
.globl vector96
vector96:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $96
80106339:	6a 60                	push   $0x60
  jmp alltraps
8010633b:	e9 ba f7 ff ff       	jmp    80105afa <alltraps>

80106340 <vector97>:
.globl vector97
vector97:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $97
80106342:	6a 61                	push   $0x61
  jmp alltraps
80106344:	e9 b1 f7 ff ff       	jmp    80105afa <alltraps>

80106349 <vector98>:
.globl vector98
vector98:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $98
8010634b:	6a 62                	push   $0x62
  jmp alltraps
8010634d:	e9 a8 f7 ff ff       	jmp    80105afa <alltraps>

80106352 <vector99>:
.globl vector99
vector99:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $99
80106354:	6a 63                	push   $0x63
  jmp alltraps
80106356:	e9 9f f7 ff ff       	jmp    80105afa <alltraps>

8010635b <vector100>:
.globl vector100
vector100:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $100
8010635d:	6a 64                	push   $0x64
  jmp alltraps
8010635f:	e9 96 f7 ff ff       	jmp    80105afa <alltraps>

80106364 <vector101>:
.globl vector101
vector101:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $101
80106366:	6a 65                	push   $0x65
  jmp alltraps
80106368:	e9 8d f7 ff ff       	jmp    80105afa <alltraps>

8010636d <vector102>:
.globl vector102
vector102:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $102
8010636f:	6a 66                	push   $0x66
  jmp alltraps
80106371:	e9 84 f7 ff ff       	jmp    80105afa <alltraps>

80106376 <vector103>:
.globl vector103
vector103:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $103
80106378:	6a 67                	push   $0x67
  jmp alltraps
8010637a:	e9 7b f7 ff ff       	jmp    80105afa <alltraps>

8010637f <vector104>:
.globl vector104
vector104:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $104
80106381:	6a 68                	push   $0x68
  jmp alltraps
80106383:	e9 72 f7 ff ff       	jmp    80105afa <alltraps>

80106388 <vector105>:
.globl vector105
vector105:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $105
8010638a:	6a 69                	push   $0x69
  jmp alltraps
8010638c:	e9 69 f7 ff ff       	jmp    80105afa <alltraps>

80106391 <vector106>:
.globl vector106
vector106:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $106
80106393:	6a 6a                	push   $0x6a
  jmp alltraps
80106395:	e9 60 f7 ff ff       	jmp    80105afa <alltraps>

8010639a <vector107>:
.globl vector107
vector107:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $107
8010639c:	6a 6b                	push   $0x6b
  jmp alltraps
8010639e:	e9 57 f7 ff ff       	jmp    80105afa <alltraps>

801063a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $108
801063a5:	6a 6c                	push   $0x6c
  jmp alltraps
801063a7:	e9 4e f7 ff ff       	jmp    80105afa <alltraps>

801063ac <vector109>:
.globl vector109
vector109:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $109
801063ae:	6a 6d                	push   $0x6d
  jmp alltraps
801063b0:	e9 45 f7 ff ff       	jmp    80105afa <alltraps>

801063b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $110
801063b7:	6a 6e                	push   $0x6e
  jmp alltraps
801063b9:	e9 3c f7 ff ff       	jmp    80105afa <alltraps>

801063be <vector111>:
.globl vector111
vector111:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $111
801063c0:	6a 6f                	push   $0x6f
  jmp alltraps
801063c2:	e9 33 f7 ff ff       	jmp    80105afa <alltraps>

801063c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $112
801063c9:	6a 70                	push   $0x70
  jmp alltraps
801063cb:	e9 2a f7 ff ff       	jmp    80105afa <alltraps>

801063d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $113
801063d2:	6a 71                	push   $0x71
  jmp alltraps
801063d4:	e9 21 f7 ff ff       	jmp    80105afa <alltraps>

801063d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $114
801063db:	6a 72                	push   $0x72
  jmp alltraps
801063dd:	e9 18 f7 ff ff       	jmp    80105afa <alltraps>

801063e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $115
801063e4:	6a 73                	push   $0x73
  jmp alltraps
801063e6:	e9 0f f7 ff ff       	jmp    80105afa <alltraps>

801063eb <vector116>:
.globl vector116
vector116:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $116
801063ed:	6a 74                	push   $0x74
  jmp alltraps
801063ef:	e9 06 f7 ff ff       	jmp    80105afa <alltraps>

801063f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $117
801063f6:	6a 75                	push   $0x75
  jmp alltraps
801063f8:	e9 fd f6 ff ff       	jmp    80105afa <alltraps>

801063fd <vector118>:
.globl vector118
vector118:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $118
801063ff:	6a 76                	push   $0x76
  jmp alltraps
80106401:	e9 f4 f6 ff ff       	jmp    80105afa <alltraps>

80106406 <vector119>:
.globl vector119
vector119:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $119
80106408:	6a 77                	push   $0x77
  jmp alltraps
8010640a:	e9 eb f6 ff ff       	jmp    80105afa <alltraps>

8010640f <vector120>:
.globl vector120
vector120:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $120
80106411:	6a 78                	push   $0x78
  jmp alltraps
80106413:	e9 e2 f6 ff ff       	jmp    80105afa <alltraps>

80106418 <vector121>:
.globl vector121
vector121:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $121
8010641a:	6a 79                	push   $0x79
  jmp alltraps
8010641c:	e9 d9 f6 ff ff       	jmp    80105afa <alltraps>

80106421 <vector122>:
.globl vector122
vector122:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $122
80106423:	6a 7a                	push   $0x7a
  jmp alltraps
80106425:	e9 d0 f6 ff ff       	jmp    80105afa <alltraps>

8010642a <vector123>:
.globl vector123
vector123:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $123
8010642c:	6a 7b                	push   $0x7b
  jmp alltraps
8010642e:	e9 c7 f6 ff ff       	jmp    80105afa <alltraps>

80106433 <vector124>:
.globl vector124
vector124:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $124
80106435:	6a 7c                	push   $0x7c
  jmp alltraps
80106437:	e9 be f6 ff ff       	jmp    80105afa <alltraps>

8010643c <vector125>:
.globl vector125
vector125:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $125
8010643e:	6a 7d                	push   $0x7d
  jmp alltraps
80106440:	e9 b5 f6 ff ff       	jmp    80105afa <alltraps>

80106445 <vector126>:
.globl vector126
vector126:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $126
80106447:	6a 7e                	push   $0x7e
  jmp alltraps
80106449:	e9 ac f6 ff ff       	jmp    80105afa <alltraps>

8010644e <vector127>:
.globl vector127
vector127:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $127
80106450:	6a 7f                	push   $0x7f
  jmp alltraps
80106452:	e9 a3 f6 ff ff       	jmp    80105afa <alltraps>

80106457 <vector128>:
.globl vector128
vector128:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $128
80106459:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010645e:	e9 97 f6 ff ff       	jmp    80105afa <alltraps>

80106463 <vector129>:
.globl vector129
vector129:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $129
80106465:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010646a:	e9 8b f6 ff ff       	jmp    80105afa <alltraps>

8010646f <vector130>:
.globl vector130
vector130:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $130
80106471:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106476:	e9 7f f6 ff ff       	jmp    80105afa <alltraps>

8010647b <vector131>:
.globl vector131
vector131:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $131
8010647d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106482:	e9 73 f6 ff ff       	jmp    80105afa <alltraps>

80106487 <vector132>:
.globl vector132
vector132:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $132
80106489:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010648e:	e9 67 f6 ff ff       	jmp    80105afa <alltraps>

80106493 <vector133>:
.globl vector133
vector133:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $133
80106495:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010649a:	e9 5b f6 ff ff       	jmp    80105afa <alltraps>

8010649f <vector134>:
.globl vector134
vector134:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $134
801064a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064a6:	e9 4f f6 ff ff       	jmp    80105afa <alltraps>

801064ab <vector135>:
.globl vector135
vector135:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $135
801064ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064b2:	e9 43 f6 ff ff       	jmp    80105afa <alltraps>

801064b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $136
801064b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064be:	e9 37 f6 ff ff       	jmp    80105afa <alltraps>

801064c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $137
801064c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064ca:	e9 2b f6 ff ff       	jmp    80105afa <alltraps>

801064cf <vector138>:
.globl vector138
vector138:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $138
801064d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064d6:	e9 1f f6 ff ff       	jmp    80105afa <alltraps>

801064db <vector139>:
.globl vector139
vector139:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $139
801064dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064e2:	e9 13 f6 ff ff       	jmp    80105afa <alltraps>

801064e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $140
801064e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064ee:	e9 07 f6 ff ff       	jmp    80105afa <alltraps>

801064f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $141
801064f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064fa:	e9 fb f5 ff ff       	jmp    80105afa <alltraps>

801064ff <vector142>:
.globl vector142
vector142:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $142
80106501:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106506:	e9 ef f5 ff ff       	jmp    80105afa <alltraps>

8010650b <vector143>:
.globl vector143
vector143:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $143
8010650d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106512:	e9 e3 f5 ff ff       	jmp    80105afa <alltraps>

80106517 <vector144>:
.globl vector144
vector144:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $144
80106519:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010651e:	e9 d7 f5 ff ff       	jmp    80105afa <alltraps>

80106523 <vector145>:
.globl vector145
vector145:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $145
80106525:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010652a:	e9 cb f5 ff ff       	jmp    80105afa <alltraps>

8010652f <vector146>:
.globl vector146
vector146:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $146
80106531:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106536:	e9 bf f5 ff ff       	jmp    80105afa <alltraps>

8010653b <vector147>:
.globl vector147
vector147:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $147
8010653d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106542:	e9 b3 f5 ff ff       	jmp    80105afa <alltraps>

80106547 <vector148>:
.globl vector148
vector148:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $148
80106549:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010654e:	e9 a7 f5 ff ff       	jmp    80105afa <alltraps>

80106553 <vector149>:
.globl vector149
vector149:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $149
80106555:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010655a:	e9 9b f5 ff ff       	jmp    80105afa <alltraps>

8010655f <vector150>:
.globl vector150
vector150:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $150
80106561:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106566:	e9 8f f5 ff ff       	jmp    80105afa <alltraps>

8010656b <vector151>:
.globl vector151
vector151:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $151
8010656d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106572:	e9 83 f5 ff ff       	jmp    80105afa <alltraps>

80106577 <vector152>:
.globl vector152
vector152:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $152
80106579:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010657e:	e9 77 f5 ff ff       	jmp    80105afa <alltraps>

80106583 <vector153>:
.globl vector153
vector153:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $153
80106585:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010658a:	e9 6b f5 ff ff       	jmp    80105afa <alltraps>

8010658f <vector154>:
.globl vector154
vector154:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $154
80106591:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106596:	e9 5f f5 ff ff       	jmp    80105afa <alltraps>

8010659b <vector155>:
.globl vector155
vector155:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $155
8010659d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065a2:	e9 53 f5 ff ff       	jmp    80105afa <alltraps>

801065a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $156
801065a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065ae:	e9 47 f5 ff ff       	jmp    80105afa <alltraps>

801065b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $157
801065b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ba:	e9 3b f5 ff ff       	jmp    80105afa <alltraps>

801065bf <vector158>:
.globl vector158
vector158:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $158
801065c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065c6:	e9 2f f5 ff ff       	jmp    80105afa <alltraps>

801065cb <vector159>:
.globl vector159
vector159:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $159
801065cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065d2:	e9 23 f5 ff ff       	jmp    80105afa <alltraps>

801065d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $160
801065d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065de:	e9 17 f5 ff ff       	jmp    80105afa <alltraps>

801065e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $161
801065e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065ea:	e9 0b f5 ff ff       	jmp    80105afa <alltraps>

801065ef <vector162>:
.globl vector162
vector162:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $162
801065f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065f6:	e9 ff f4 ff ff       	jmp    80105afa <alltraps>

801065fb <vector163>:
.globl vector163
vector163:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $163
801065fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106602:	e9 f3 f4 ff ff       	jmp    80105afa <alltraps>

80106607 <vector164>:
.globl vector164
vector164:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $164
80106609:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010660e:	e9 e7 f4 ff ff       	jmp    80105afa <alltraps>

80106613 <vector165>:
.globl vector165
vector165:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $165
80106615:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010661a:	e9 db f4 ff ff       	jmp    80105afa <alltraps>

8010661f <vector166>:
.globl vector166
vector166:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $166
80106621:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106626:	e9 cf f4 ff ff       	jmp    80105afa <alltraps>

8010662b <vector167>:
.globl vector167
vector167:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $167
8010662d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106632:	e9 c3 f4 ff ff       	jmp    80105afa <alltraps>

80106637 <vector168>:
.globl vector168
vector168:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $168
80106639:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010663e:	e9 b7 f4 ff ff       	jmp    80105afa <alltraps>

80106643 <vector169>:
.globl vector169
vector169:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $169
80106645:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010664a:	e9 ab f4 ff ff       	jmp    80105afa <alltraps>

8010664f <vector170>:
.globl vector170
vector170:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $170
80106651:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106656:	e9 9f f4 ff ff       	jmp    80105afa <alltraps>

8010665b <vector171>:
.globl vector171
vector171:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $171
8010665d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106662:	e9 93 f4 ff ff       	jmp    80105afa <alltraps>

80106667 <vector172>:
.globl vector172
vector172:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $172
80106669:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010666e:	e9 87 f4 ff ff       	jmp    80105afa <alltraps>

80106673 <vector173>:
.globl vector173
vector173:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $173
80106675:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010667a:	e9 7b f4 ff ff       	jmp    80105afa <alltraps>

8010667f <vector174>:
.globl vector174
vector174:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $174
80106681:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106686:	e9 6f f4 ff ff       	jmp    80105afa <alltraps>

8010668b <vector175>:
.globl vector175
vector175:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $175
8010668d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106692:	e9 63 f4 ff ff       	jmp    80105afa <alltraps>

80106697 <vector176>:
.globl vector176
vector176:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $176
80106699:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010669e:	e9 57 f4 ff ff       	jmp    80105afa <alltraps>

801066a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $177
801066a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066aa:	e9 4b f4 ff ff       	jmp    80105afa <alltraps>

801066af <vector178>:
.globl vector178
vector178:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $178
801066b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066b6:	e9 3f f4 ff ff       	jmp    80105afa <alltraps>

801066bb <vector179>:
.globl vector179
vector179:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $179
801066bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066c2:	e9 33 f4 ff ff       	jmp    80105afa <alltraps>

801066c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $180
801066c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066ce:	e9 27 f4 ff ff       	jmp    80105afa <alltraps>

801066d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $181
801066d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066da:	e9 1b f4 ff ff       	jmp    80105afa <alltraps>

801066df <vector182>:
.globl vector182
vector182:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $182
801066e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066e6:	e9 0f f4 ff ff       	jmp    80105afa <alltraps>

801066eb <vector183>:
.globl vector183
vector183:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $183
801066ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066f2:	e9 03 f4 ff ff       	jmp    80105afa <alltraps>

801066f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $184
801066f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066fe:	e9 f7 f3 ff ff       	jmp    80105afa <alltraps>

80106703 <vector185>:
.globl vector185
vector185:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $185
80106705:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010670a:	e9 eb f3 ff ff       	jmp    80105afa <alltraps>

8010670f <vector186>:
.globl vector186
vector186:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $186
80106711:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106716:	e9 df f3 ff ff       	jmp    80105afa <alltraps>

8010671b <vector187>:
.globl vector187
vector187:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $187
8010671d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106722:	e9 d3 f3 ff ff       	jmp    80105afa <alltraps>

80106727 <vector188>:
.globl vector188
vector188:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $188
80106729:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010672e:	e9 c7 f3 ff ff       	jmp    80105afa <alltraps>

80106733 <vector189>:
.globl vector189
vector189:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $189
80106735:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010673a:	e9 bb f3 ff ff       	jmp    80105afa <alltraps>

8010673f <vector190>:
.globl vector190
vector190:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $190
80106741:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106746:	e9 af f3 ff ff       	jmp    80105afa <alltraps>

8010674b <vector191>:
.globl vector191
vector191:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $191
8010674d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106752:	e9 a3 f3 ff ff       	jmp    80105afa <alltraps>

80106757 <vector192>:
.globl vector192
vector192:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $192
80106759:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010675e:	e9 97 f3 ff ff       	jmp    80105afa <alltraps>

80106763 <vector193>:
.globl vector193
vector193:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $193
80106765:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010676a:	e9 8b f3 ff ff       	jmp    80105afa <alltraps>

8010676f <vector194>:
.globl vector194
vector194:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $194
80106771:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106776:	e9 7f f3 ff ff       	jmp    80105afa <alltraps>

8010677b <vector195>:
.globl vector195
vector195:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $195
8010677d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106782:	e9 73 f3 ff ff       	jmp    80105afa <alltraps>

80106787 <vector196>:
.globl vector196
vector196:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $196
80106789:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010678e:	e9 67 f3 ff ff       	jmp    80105afa <alltraps>

80106793 <vector197>:
.globl vector197
vector197:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $197
80106795:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010679a:	e9 5b f3 ff ff       	jmp    80105afa <alltraps>

8010679f <vector198>:
.globl vector198
vector198:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $198
801067a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067a6:	e9 4f f3 ff ff       	jmp    80105afa <alltraps>

801067ab <vector199>:
.globl vector199
vector199:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $199
801067ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067b2:	e9 43 f3 ff ff       	jmp    80105afa <alltraps>

801067b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $200
801067b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067be:	e9 37 f3 ff ff       	jmp    80105afa <alltraps>

801067c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $201
801067c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067ca:	e9 2b f3 ff ff       	jmp    80105afa <alltraps>

801067cf <vector202>:
.globl vector202
vector202:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $202
801067d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067d6:	e9 1f f3 ff ff       	jmp    80105afa <alltraps>

801067db <vector203>:
.globl vector203
vector203:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $203
801067dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067e2:	e9 13 f3 ff ff       	jmp    80105afa <alltraps>

801067e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $204
801067e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067ee:	e9 07 f3 ff ff       	jmp    80105afa <alltraps>

801067f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $205
801067f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067fa:	e9 fb f2 ff ff       	jmp    80105afa <alltraps>

801067ff <vector206>:
.globl vector206
vector206:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $206
80106801:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106806:	e9 ef f2 ff ff       	jmp    80105afa <alltraps>

8010680b <vector207>:
.globl vector207
vector207:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $207
8010680d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106812:	e9 e3 f2 ff ff       	jmp    80105afa <alltraps>

80106817 <vector208>:
.globl vector208
vector208:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $208
80106819:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010681e:	e9 d7 f2 ff ff       	jmp    80105afa <alltraps>

80106823 <vector209>:
.globl vector209
vector209:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $209
80106825:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010682a:	e9 cb f2 ff ff       	jmp    80105afa <alltraps>

8010682f <vector210>:
.globl vector210
vector210:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $210
80106831:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106836:	e9 bf f2 ff ff       	jmp    80105afa <alltraps>

8010683b <vector211>:
.globl vector211
vector211:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $211
8010683d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106842:	e9 b3 f2 ff ff       	jmp    80105afa <alltraps>

80106847 <vector212>:
.globl vector212
vector212:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $212
80106849:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010684e:	e9 a7 f2 ff ff       	jmp    80105afa <alltraps>

80106853 <vector213>:
.globl vector213
vector213:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $213
80106855:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010685a:	e9 9b f2 ff ff       	jmp    80105afa <alltraps>

8010685f <vector214>:
.globl vector214
vector214:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $214
80106861:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106866:	e9 8f f2 ff ff       	jmp    80105afa <alltraps>

8010686b <vector215>:
.globl vector215
vector215:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $215
8010686d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106872:	e9 83 f2 ff ff       	jmp    80105afa <alltraps>

80106877 <vector216>:
.globl vector216
vector216:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $216
80106879:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010687e:	e9 77 f2 ff ff       	jmp    80105afa <alltraps>

80106883 <vector217>:
.globl vector217
vector217:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $217
80106885:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010688a:	e9 6b f2 ff ff       	jmp    80105afa <alltraps>

8010688f <vector218>:
.globl vector218
vector218:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $218
80106891:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106896:	e9 5f f2 ff ff       	jmp    80105afa <alltraps>

8010689b <vector219>:
.globl vector219
vector219:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $219
8010689d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068a2:	e9 53 f2 ff ff       	jmp    80105afa <alltraps>

801068a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $220
801068a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068ae:	e9 47 f2 ff ff       	jmp    80105afa <alltraps>

801068b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $221
801068b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ba:	e9 3b f2 ff ff       	jmp    80105afa <alltraps>

801068bf <vector222>:
.globl vector222
vector222:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $222
801068c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068c6:	e9 2f f2 ff ff       	jmp    80105afa <alltraps>

801068cb <vector223>:
.globl vector223
vector223:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $223
801068cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068d2:	e9 23 f2 ff ff       	jmp    80105afa <alltraps>

801068d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $224
801068d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068de:	e9 17 f2 ff ff       	jmp    80105afa <alltraps>

801068e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $225
801068e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068ea:	e9 0b f2 ff ff       	jmp    80105afa <alltraps>

801068ef <vector226>:
.globl vector226
vector226:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $226
801068f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068f6:	e9 ff f1 ff ff       	jmp    80105afa <alltraps>

801068fb <vector227>:
.globl vector227
vector227:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $227
801068fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106902:	e9 f3 f1 ff ff       	jmp    80105afa <alltraps>

80106907 <vector228>:
.globl vector228
vector228:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $228
80106909:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010690e:	e9 e7 f1 ff ff       	jmp    80105afa <alltraps>

80106913 <vector229>:
.globl vector229
vector229:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $229
80106915:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010691a:	e9 db f1 ff ff       	jmp    80105afa <alltraps>

8010691f <vector230>:
.globl vector230
vector230:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $230
80106921:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106926:	e9 cf f1 ff ff       	jmp    80105afa <alltraps>

8010692b <vector231>:
.globl vector231
vector231:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $231
8010692d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106932:	e9 c3 f1 ff ff       	jmp    80105afa <alltraps>

80106937 <vector232>:
.globl vector232
vector232:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $232
80106939:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010693e:	e9 b7 f1 ff ff       	jmp    80105afa <alltraps>

80106943 <vector233>:
.globl vector233
vector233:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $233
80106945:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010694a:	e9 ab f1 ff ff       	jmp    80105afa <alltraps>

8010694f <vector234>:
.globl vector234
vector234:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $234
80106951:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106956:	e9 9f f1 ff ff       	jmp    80105afa <alltraps>

8010695b <vector235>:
.globl vector235
vector235:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $235
8010695d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106962:	e9 93 f1 ff ff       	jmp    80105afa <alltraps>

80106967 <vector236>:
.globl vector236
vector236:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $236
80106969:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010696e:	e9 87 f1 ff ff       	jmp    80105afa <alltraps>

80106973 <vector237>:
.globl vector237
vector237:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $237
80106975:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010697a:	e9 7b f1 ff ff       	jmp    80105afa <alltraps>

8010697f <vector238>:
.globl vector238
vector238:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $238
80106981:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106986:	e9 6f f1 ff ff       	jmp    80105afa <alltraps>

8010698b <vector239>:
.globl vector239
vector239:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $239
8010698d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106992:	e9 63 f1 ff ff       	jmp    80105afa <alltraps>

80106997 <vector240>:
.globl vector240
vector240:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $240
80106999:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010699e:	e9 57 f1 ff ff       	jmp    80105afa <alltraps>

801069a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $241
801069a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069aa:	e9 4b f1 ff ff       	jmp    80105afa <alltraps>

801069af <vector242>:
.globl vector242
vector242:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $242
801069b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069b6:	e9 3f f1 ff ff       	jmp    80105afa <alltraps>

801069bb <vector243>:
.globl vector243
vector243:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $243
801069bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069c2:	e9 33 f1 ff ff       	jmp    80105afa <alltraps>

801069c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $244
801069c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069ce:	e9 27 f1 ff ff       	jmp    80105afa <alltraps>

801069d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $245
801069d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069da:	e9 1b f1 ff ff       	jmp    80105afa <alltraps>

801069df <vector246>:
.globl vector246
vector246:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $246
801069e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069e6:	e9 0f f1 ff ff       	jmp    80105afa <alltraps>

801069eb <vector247>:
.globl vector247
vector247:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $247
801069ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069f2:	e9 03 f1 ff ff       	jmp    80105afa <alltraps>

801069f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $248
801069f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069fe:	e9 f7 f0 ff ff       	jmp    80105afa <alltraps>

80106a03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $249
80106a05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a0a:	e9 eb f0 ff ff       	jmp    80105afa <alltraps>

80106a0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $250
80106a11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a16:	e9 df f0 ff ff       	jmp    80105afa <alltraps>

80106a1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $251
80106a1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a22:	e9 d3 f0 ff ff       	jmp    80105afa <alltraps>

80106a27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $252
80106a29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a2e:	e9 c7 f0 ff ff       	jmp    80105afa <alltraps>

80106a33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $253
80106a35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a3a:	e9 bb f0 ff ff       	jmp    80105afa <alltraps>

80106a3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $254
80106a41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a46:	e9 af f0 ff ff       	jmp    80105afa <alltraps>

80106a4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $255
80106a4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a52:	e9 a3 f0 ff ff       	jmp    80105afa <alltraps>
80106a57:	66 90                	xchg   %ax,%ax
80106a59:	66 90                	xchg   %ax,%ax
80106a5b:	66 90                	xchg   %ax,%ax
80106a5d:	66 90                	xchg   %ax,%ax
80106a5f:	90                   	nop

80106a60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a72:	83 ec 1c             	sub    $0x1c,%esp
80106a75:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a78:	39 d3                	cmp    %edx,%ebx
80106a7a:	73 49                	jae    80106ac5 <deallocuvm.part.0+0x65>
80106a7c:	89 c7                	mov    %eax,%edi
80106a7e:	eb 0c                	jmp    80106a8c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a80:	83 c0 01             	add    $0x1,%eax
80106a83:	c1 e0 16             	shl    $0x16,%eax
80106a86:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a88:	39 da                	cmp    %ebx,%edx
80106a8a:	76 39                	jbe    80106ac5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106a8c:	89 d8                	mov    %ebx,%eax
80106a8e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a91:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106a94:	f6 c1 01             	test   $0x1,%cl
80106a97:	74 e7                	je     80106a80 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106a99:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106aa1:	c1 ee 0a             	shr    $0xa,%esi
80106aa4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106aaa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ab1:	85 f6                	test   %esi,%esi
80106ab3:	74 cb                	je     80106a80 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ab5:	8b 06                	mov    (%esi),%eax
80106ab7:	a8 01                	test   $0x1,%al
80106ab9:	75 15                	jne    80106ad0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106abb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ac1:	39 da                	cmp    %ebx,%edx
80106ac3:	77 c7                	ja     80106a8c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106acb:	5b                   	pop    %ebx
80106acc:	5e                   	pop    %esi
80106acd:	5f                   	pop    %edi
80106ace:	5d                   	pop    %ebp
80106acf:	c3                   	ret    
      if(pa == 0)
80106ad0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ad5:	74 25                	je     80106afc <deallocuvm.part.0+0x9c>
      kfree(v);
80106ad7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ada:	05 00 00 00 80       	add    $0x80000000,%eax
80106adf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ae2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ae8:	50                   	push   %eax
80106ae9:	e8 92 bc ff ff       	call   80102780 <kfree>
      *pte = 0;
80106aee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106af7:	83 c4 10             	add    $0x10,%esp
80106afa:	eb 8c                	jmp    80106a88 <deallocuvm.part.0+0x28>
        panic("kfree");
80106afc:	83 ec 0c             	sub    $0xc,%esp
80106aff:	68 fe 76 10 80       	push   $0x801076fe
80106b04:	e8 77 98 ff ff       	call   80100380 <panic>
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b10 <mappages>:
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b16:	89 d3                	mov    %edx,%ebx
80106b18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b1e:	83 ec 1c             	sub    $0x1c,%esp
80106b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b30:	8b 45 08             	mov    0x8(%ebp),%eax
80106b33:	29 d8                	sub    %ebx,%eax
80106b35:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b38:	eb 3d                	jmp    80106b77 <mappages+0x67>
80106b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b40:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b47:	c1 ea 0a             	shr    $0xa,%edx
80106b4a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b50:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b57:	85 c0                	test   %eax,%eax
80106b59:	74 75                	je     80106bd0 <mappages+0xc0>
    if(*pte & PTE_P)
80106b5b:	f6 00 01             	testb  $0x1,(%eax)
80106b5e:	0f 85 86 00 00 00    	jne    80106bea <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b64:	0b 75 0c             	or     0xc(%ebp),%esi
80106b67:	83 ce 01             	or     $0x1,%esi
80106b6a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b6c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106b6f:	74 6f                	je     80106be0 <mappages+0xd0>
    a += PGSIZE;
80106b71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b7a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b7d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106b80:	89 d8                	mov    %ebx,%eax
80106b82:	c1 e8 16             	shr    $0x16,%eax
80106b85:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b88:	8b 07                	mov    (%edi),%eax
80106b8a:	a8 01                	test   $0x1,%al
80106b8c:	75 b2                	jne    80106b40 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b8e:	e8 ad bd ff ff       	call   80102940 <kalloc>
80106b93:	85 c0                	test   %eax,%eax
80106b95:	74 39                	je     80106bd0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b97:	83 ec 04             	sub    $0x4,%esp
80106b9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b9d:	68 00 10 00 00       	push   $0x1000
80106ba2:	6a 00                	push   $0x0
80106ba4:	50                   	push   %eax
80106ba5:	e8 76 dd ff ff       	call   80104920 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106baa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106bad:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bb0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106bb6:	83 c8 07             	or     $0x7,%eax
80106bb9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106bbb:	89 d8                	mov    %ebx,%eax
80106bbd:	c1 e8 0a             	shr    $0xa,%eax
80106bc0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bc5:	01 d0                	add    %edx,%eax
80106bc7:	eb 92                	jmp    80106b5b <mappages+0x4b>
80106bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bd8:	5b                   	pop    %ebx
80106bd9:	5e                   	pop    %esi
80106bda:	5f                   	pop    %edi
80106bdb:	5d                   	pop    %ebp
80106bdc:	c3                   	ret    
80106bdd:	8d 76 00             	lea    0x0(%esi),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
      panic("remap");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 48 7d 10 80       	push   $0x80107d48
80106bf2:	e8 89 97 ff ff       	call   80100380 <panic>
80106bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bfe:	66 90                	xchg   %ax,%ax

80106c00 <seginit>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c06:	e8 05 d0 ff ff       	call   80103c10 <cpuid>
  pd[0] = size-1;
80106c0b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c10:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c1a:	c7 80 b8 18 11 80 ff 	movl   $0xffff,-0x7feee748(%eax)
80106c21:	ff 00 00 
80106c24:	c7 80 bc 18 11 80 00 	movl   $0xcf9a00,-0x7feee744(%eax)
80106c2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c2e:	c7 80 c0 18 11 80 ff 	movl   $0xffff,-0x7feee740(%eax)
80106c35:	ff 00 00 
80106c38:	c7 80 c4 18 11 80 00 	movl   $0xcf9200,-0x7feee73c(%eax)
80106c3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c42:	c7 80 c8 18 11 80 ff 	movl   $0xffff,-0x7feee738(%eax)
80106c49:	ff 00 00 
80106c4c:	c7 80 cc 18 11 80 00 	movl   $0xcffa00,-0x7feee734(%eax)
80106c53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c56:	c7 80 d0 18 11 80 ff 	movl   $0xffff,-0x7feee730(%eax)
80106c5d:	ff 00 00 
80106c60:	c7 80 d4 18 11 80 00 	movl   $0xcff200,-0x7feee72c(%eax)
80106c67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c6a:	05 b0 18 11 80       	add    $0x801118b0,%eax
  pd[1] = (uint)p;
80106c6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c73:	c1 e8 10             	shr    $0x10,%eax
80106c76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c7d:	0f 01 10             	lgdtl  (%eax)
}
80106c80:	c9                   	leave  
80106c81:	c3                   	ret    
80106c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c90 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c90:	a1 64 45 11 80       	mov    0x80114564,%eax
80106c95:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c9a:	0f 22 d8             	mov    %eax,%cr3
}
80106c9d:	c3                   	ret    
80106c9e:	66 90                	xchg   %ax,%ax

80106ca0 <switchuvm>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106cac:	85 f6                	test   %esi,%esi
80106cae:	0f 84 cb 00 00 00    	je     80106d7f <switchuvm+0xdf>
  if(p->kstack == 0)
80106cb4:	8b 46 08             	mov    0x8(%esi),%eax
80106cb7:	85 c0                	test   %eax,%eax
80106cb9:	0f 84 da 00 00 00    	je     80106d99 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106cbf:	8b 46 04             	mov    0x4(%esi),%eax
80106cc2:	85 c0                	test   %eax,%eax
80106cc4:	0f 84 c2 00 00 00    	je     80106d8c <switchuvm+0xec>
  pushcli();
80106cca:	e8 41 da ff ff       	call   80104710 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ccf:	e8 dc ce ff ff       	call   80103bb0 <mycpu>
80106cd4:	89 c3                	mov    %eax,%ebx
80106cd6:	e8 d5 ce ff ff       	call   80103bb0 <mycpu>
80106cdb:	89 c7                	mov    %eax,%edi
80106cdd:	e8 ce ce ff ff       	call   80103bb0 <mycpu>
80106ce2:	83 c7 08             	add    $0x8,%edi
80106ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ce8:	e8 c3 ce ff ff       	call   80103bb0 <mycpu>
80106ced:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cf0:	ba 67 00 00 00       	mov    $0x67,%edx
80106cf5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cfc:	83 c0 08             	add    $0x8,%eax
80106cff:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d06:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d0b:	83 c1 08             	add    $0x8,%ecx
80106d0e:	c1 e8 18             	shr    $0x18,%eax
80106d11:	c1 e9 10             	shr    $0x10,%ecx
80106d14:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d1a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d20:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d25:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d31:	e8 7a ce ff ff       	call   80103bb0 <mycpu>
80106d36:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d3d:	e8 6e ce ff ff       	call   80103bb0 <mycpu>
80106d42:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d46:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4f:	e8 5c ce ff ff       	call   80103bb0 <mycpu>
80106d54:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d57:	e8 54 ce ff ff       	call   80103bb0 <mycpu>
80106d5c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d60:	b8 28 00 00 00       	mov    $0x28,%eax
80106d65:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d68:	8b 46 04             	mov    0x4(%esi),%eax
80106d6b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d70:	0f 22 d8             	mov    %eax,%cr3
}
80106d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d76:	5b                   	pop    %ebx
80106d77:	5e                   	pop    %esi
80106d78:	5f                   	pop    %edi
80106d79:	5d                   	pop    %ebp
  popcli();
80106d7a:	e9 e1 d9 ff ff       	jmp    80104760 <popcli>
    panic("switchuvm: no process");
80106d7f:	83 ec 0c             	sub    $0xc,%esp
80106d82:	68 4e 7d 10 80       	push   $0x80107d4e
80106d87:	e8 f4 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d8c:	83 ec 0c             	sub    $0xc,%esp
80106d8f:	68 79 7d 10 80       	push   $0x80107d79
80106d94:	e8 e7 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d99:	83 ec 0c             	sub    $0xc,%esp
80106d9c:	68 64 7d 10 80       	push   $0x80107d64
80106da1:	e8 da 95 ff ff       	call   80100380 <panic>
80106da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dad:	8d 76 00             	lea    0x0(%esi),%esi

80106db0 <inituvm>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 1c             	sub    $0x1c,%esp
80106db9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dbc:	8b 75 10             	mov    0x10(%ebp),%esi
80106dbf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106dc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106dc5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dcb:	77 4b                	ja     80106e18 <inituvm+0x68>
  mem = kalloc();
80106dcd:	e8 6e bb ff ff       	call   80102940 <kalloc>
  memset(mem, 0, PGSIZE);
80106dd2:	83 ec 04             	sub    $0x4,%esp
80106dd5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dda:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ddc:	6a 00                	push   $0x0
80106dde:	50                   	push   %eax
80106ddf:	e8 3c db ff ff       	call   80104920 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106de4:	58                   	pop    %eax
80106de5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106deb:	5a                   	pop    %edx
80106dec:	6a 06                	push   $0x6
80106dee:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106df3:	31 d2                	xor    %edx,%edx
80106df5:	50                   	push   %eax
80106df6:	89 f8                	mov    %edi,%eax
80106df8:	e8 13 fd ff ff       	call   80106b10 <mappages>
  memmove(mem, init, sz);
80106dfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e00:	89 75 10             	mov    %esi,0x10(%ebp)
80106e03:	83 c4 10             	add    $0x10,%esp
80106e06:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e09:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e0f:	5b                   	pop    %ebx
80106e10:	5e                   	pop    %esi
80106e11:	5f                   	pop    %edi
80106e12:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e13:	e9 a8 db ff ff       	jmp    801049c0 <memmove>
    panic("inituvm: more than a page");
80106e18:	83 ec 0c             	sub    $0xc,%esp
80106e1b:	68 8d 7d 10 80       	push   $0x80107d8d
80106e20:	e8 5b 95 ff ff       	call   80100380 <panic>
80106e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e30 <loaduvm>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
80106e39:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e3c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e3f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e44:	0f 85 bb 00 00 00    	jne    80106f05 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106e4a:	01 f0                	add    %esi,%eax
80106e4c:	89 f3                	mov    %esi,%ebx
80106e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e51:	8b 45 14             	mov    0x14(%ebp),%eax
80106e54:	01 f0                	add    %esi,%eax
80106e56:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e59:	85 f6                	test   %esi,%esi
80106e5b:	0f 84 87 00 00 00    	je     80106ee8 <loaduvm+0xb8>
80106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106e6e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106e70:	89 c2                	mov    %eax,%edx
80106e72:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106e75:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106e78:	f6 c2 01             	test   $0x1,%dl
80106e7b:	75 13                	jne    80106e90 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106e7d:	83 ec 0c             	sub    $0xc,%esp
80106e80:	68 a7 7d 10 80       	push   $0x80107da7
80106e85:	e8 f6 94 ff ff       	call   80100380 <panic>
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106e99:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ea5:	85 c0                	test   %eax,%eax
80106ea7:	74 d4                	je     80106e7d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106ea9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106eae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106eb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106eb8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106ebe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ec1:	29 d9                	sub    %ebx,%ecx
80106ec3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ec8:	57                   	push   %edi
80106ec9:	51                   	push   %ecx
80106eca:	50                   	push   %eax
80106ecb:	ff 75 10             	push   0x10(%ebp)
80106ece:	e8 7d ae ff ff       	call   80101d50 <readi>
80106ed3:	83 c4 10             	add    $0x10,%esp
80106ed6:	39 f8                	cmp    %edi,%eax
80106ed8:	75 1e                	jne    80106ef8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106eda:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ee0:	89 f0                	mov    %esi,%eax
80106ee2:	29 d8                	sub    %ebx,%eax
80106ee4:	39 c6                	cmp    %eax,%esi
80106ee6:	77 80                	ja     80106e68 <loaduvm+0x38>
}
80106ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106eeb:	31 c0                	xor    %eax,%eax
}
80106eed:	5b                   	pop    %ebx
80106eee:	5e                   	pop    %esi
80106eef:	5f                   	pop    %edi
80106ef0:	5d                   	pop    %ebp
80106ef1:	c3                   	ret    
80106ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
80106f04:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f05:	83 ec 0c             	sub    $0xc,%esp
80106f08:	68 48 7e 10 80       	push   $0x80107e48
80106f0d:	e8 6e 94 ff ff       	call   80100380 <panic>
80106f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f20 <allocuvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f29:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106f2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f32:	85 c0                	test   %eax,%eax
80106f34:	0f 88 b6 00 00 00    	js     80106ff0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106f3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106f40:	0f 82 9a 00 00 00    	jb     80106fe0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f46:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106f4c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f52:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f55:	77 44                	ja     80106f9b <allocuvm+0x7b>
80106f57:	e9 87 00 00 00       	jmp    80106fe3 <allocuvm+0xc3>
80106f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f60:	83 ec 04             	sub    $0x4,%esp
80106f63:	68 00 10 00 00       	push   $0x1000
80106f68:	6a 00                	push   $0x0
80106f6a:	50                   	push   %eax
80106f6b:	e8 b0 d9 ff ff       	call   80104920 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f70:	58                   	pop    %eax
80106f71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f77:	5a                   	pop    %edx
80106f78:	6a 06                	push   $0x6
80106f7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f7f:	89 f2                	mov    %esi,%edx
80106f81:	50                   	push   %eax
80106f82:	89 f8                	mov    %edi,%eax
80106f84:	e8 87 fb ff ff       	call   80106b10 <mappages>
80106f89:	83 c4 10             	add    $0x10,%esp
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	78 78                	js     80107008 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f90:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f96:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f99:	76 48                	jbe    80106fe3 <allocuvm+0xc3>
    mem = kalloc();
80106f9b:	e8 a0 b9 ff ff       	call   80102940 <kalloc>
80106fa0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fa2:	85 c0                	test   %eax,%eax
80106fa4:	75 ba                	jne    80106f60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fa6:	83 ec 0c             	sub    $0xc,%esp
80106fa9:	68 c5 7d 10 80       	push   $0x80107dc5
80106fae:	e8 ed 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fb6:	83 c4 10             	add    $0x10,%esp
80106fb9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fbc:	74 32                	je     80106ff0 <allocuvm+0xd0>
80106fbe:	8b 55 10             	mov    0x10(%ebp),%edx
80106fc1:	89 c1                	mov    %eax,%ecx
80106fc3:	89 f8                	mov    %edi,%eax
80106fc5:	e8 96 fa ff ff       	call   80106a60 <deallocuvm.part.0>
      return 0;
80106fca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd7:	5b                   	pop    %ebx
80106fd8:	5e                   	pop    %esi
80106fd9:	5f                   	pop    %edi
80106fda:	5d                   	pop    %ebp
80106fdb:	c3                   	ret    
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe9:	5b                   	pop    %ebx
80106fea:	5e                   	pop    %esi
80106feb:	5f                   	pop    %edi
80106fec:	5d                   	pop    %ebp
80106fed:	c3                   	ret    
80106fee:	66 90                	xchg   %ax,%ax
    return 0;
80106ff0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffd:	5b                   	pop    %ebx
80106ffe:	5e                   	pop    %esi
80106fff:	5f                   	pop    %edi
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107008:	83 ec 0c             	sub    $0xc,%esp
8010700b:	68 dd 7d 10 80       	push   $0x80107ddd
80107010:	e8 8b 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107015:	8b 45 0c             	mov    0xc(%ebp),%eax
80107018:	83 c4 10             	add    $0x10,%esp
8010701b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010701e:	74 0c                	je     8010702c <allocuvm+0x10c>
80107020:	8b 55 10             	mov    0x10(%ebp),%edx
80107023:	89 c1                	mov    %eax,%ecx
80107025:	89 f8                	mov    %edi,%eax
80107027:	e8 34 fa ff ff       	call   80106a60 <deallocuvm.part.0>
      kfree(mem);
8010702c:	83 ec 0c             	sub    $0xc,%esp
8010702f:	53                   	push   %ebx
80107030:	e8 4b b7 ff ff       	call   80102780 <kfree>
      return 0;
80107035:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010703c:	83 c4 10             	add    $0x10,%esp
}
8010703f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107050 <deallocuvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	8b 55 0c             	mov    0xc(%ebp),%edx
80107056:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107059:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010705c:	39 d1                	cmp    %edx,%ecx
8010705e:	73 10                	jae    80107070 <deallocuvm+0x20>
}
80107060:	5d                   	pop    %ebp
80107061:	e9 fa f9 ff ff       	jmp    80106a60 <deallocuvm.part.0>
80107066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	89 d0                	mov    %edx,%eax
80107072:	5d                   	pop    %ebp
80107073:	c3                   	ret    
80107074:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010707b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010707f:	90                   	nop

80107080 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 0c             	sub    $0xc,%esp
80107089:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010708c:	85 f6                	test   %esi,%esi
8010708e:	74 59                	je     801070e9 <freevm+0x69>
  if(newsz >= oldsz)
80107090:	31 c9                	xor    %ecx,%ecx
80107092:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107097:	89 f0                	mov    %esi,%eax
80107099:	89 f3                	mov    %esi,%ebx
8010709b:	e8 c0 f9 ff ff       	call   80106a60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070a6:	eb 0f                	jmp    801070b7 <freevm+0x37>
801070a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070af:	90                   	nop
801070b0:	83 c3 04             	add    $0x4,%ebx
801070b3:	39 df                	cmp    %ebx,%edi
801070b5:	74 23                	je     801070da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070b7:	8b 03                	mov    (%ebx),%eax
801070b9:	a8 01                	test   $0x1,%al
801070bb:	74 f3                	je     801070b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070c2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070cd:	50                   	push   %eax
801070ce:	e8 ad b6 ff ff       	call   80102780 <kfree>
801070d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070d6:	39 df                	cmp    %ebx,%edi
801070d8:	75 dd                	jne    801070b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e0:	5b                   	pop    %ebx
801070e1:	5e                   	pop    %esi
801070e2:	5f                   	pop    %edi
801070e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070e4:	e9 97 b6 ff ff       	jmp    80102780 <kfree>
    panic("freevm: no pgdir");
801070e9:	83 ec 0c             	sub    $0xc,%esp
801070ec:	68 f9 7d 10 80       	push   $0x80107df9
801070f1:	e8 8a 92 ff ff       	call   80100380 <panic>
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi

80107100 <setupkvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	56                   	push   %esi
80107104:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107105:	e8 36 b8 ff ff       	call   80102940 <kalloc>
8010710a:	89 c6                	mov    %eax,%esi
8010710c:	85 c0                	test   %eax,%eax
8010710e:	74 42                	je     80107152 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107110:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107113:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107118:	68 00 10 00 00       	push   $0x1000
8010711d:	6a 00                	push   $0x0
8010711f:	50                   	push   %eax
80107120:	e8 fb d7 ff ff       	call   80104920 <memset>
80107125:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107128:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010712b:	83 ec 08             	sub    $0x8,%esp
8010712e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107131:	ff 73 0c             	push   0xc(%ebx)
80107134:	8b 13                	mov    (%ebx),%edx
80107136:	50                   	push   %eax
80107137:	29 c1                	sub    %eax,%ecx
80107139:	89 f0                	mov    %esi,%eax
8010713b:	e8 d0 f9 ff ff       	call   80106b10 <mappages>
80107140:	83 c4 10             	add    $0x10,%esp
80107143:	85 c0                	test   %eax,%eax
80107145:	78 19                	js     80107160 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107147:	83 c3 10             	add    $0x10,%ebx
8010714a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107150:	75 d6                	jne    80107128 <setupkvm+0x28>
}
80107152:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107155:	89 f0                	mov    %esi,%eax
80107157:	5b                   	pop    %ebx
80107158:	5e                   	pop    %esi
80107159:	5d                   	pop    %ebp
8010715a:	c3                   	ret    
8010715b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop
      freevm(pgdir);
80107160:	83 ec 0c             	sub    $0xc,%esp
80107163:	56                   	push   %esi
      return 0;
80107164:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107166:	e8 15 ff ff ff       	call   80107080 <freevm>
      return 0;
8010716b:	83 c4 10             	add    $0x10,%esp
}
8010716e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107171:	89 f0                	mov    %esi,%eax
80107173:	5b                   	pop    %ebx
80107174:	5e                   	pop    %esi
80107175:	5d                   	pop    %ebp
80107176:	c3                   	ret    
80107177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717e:	66 90                	xchg   %ax,%ax

80107180 <kvmalloc>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107186:	e8 75 ff ff ff       	call   80107100 <setupkvm>
8010718b:	a3 64 45 11 80       	mov    %eax,0x80114564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107190:	05 00 00 00 80       	add    $0x80000000,%eax
80107195:	0f 22 d8             	mov    %eax,%cr3
}
80107198:	c9                   	leave  
80107199:	c3                   	ret    
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	83 ec 08             	sub    $0x8,%esp
801071a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071a9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071ac:	89 c1                	mov    %eax,%ecx
801071ae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071b1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071b4:	f6 c2 01             	test   $0x1,%dl
801071b7:	75 17                	jne    801071d0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801071b9:	83 ec 0c             	sub    $0xc,%esp
801071bc:	68 0a 7e 10 80       	push   $0x80107e0a
801071c1:	e8 ba 91 ff ff       	call   80100380 <panic>
801071c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071cd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801071d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801071de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801071e5:	85 c0                	test   %eax,%eax
801071e7:	74 d0                	je     801071b9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801071e9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071ec:	c9                   	leave  
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax

801071f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071f9:	e8 02 ff ff ff       	call   80107100 <setupkvm>
801071fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107201:	85 c0                	test   %eax,%eax
80107203:	0f 84 bd 00 00 00    	je     801072c6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107209:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010720c:	85 c9                	test   %ecx,%ecx
8010720e:	0f 84 b2 00 00 00    	je     801072c6 <copyuvm+0xd6>
80107214:	31 f6                	xor    %esi,%esi
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107223:	89 f0                	mov    %esi,%eax
80107225:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107228:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010722b:	a8 01                	test   $0x1,%al
8010722d:	75 11                	jne    80107240 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010722f:	83 ec 0c             	sub    $0xc,%esp
80107232:	68 14 7e 10 80       	push   $0x80107e14
80107237:	e8 44 91 ff ff       	call   80100380 <panic>
8010723c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107240:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107247:	c1 ea 0a             	shr    $0xa,%edx
8010724a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107250:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107257:	85 c0                	test   %eax,%eax
80107259:	74 d4                	je     8010722f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010725b:	8b 00                	mov    (%eax),%eax
8010725d:	a8 01                	test   $0x1,%al
8010725f:	0f 84 9f 00 00 00    	je     80107304 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107265:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107267:	25 ff 0f 00 00       	and    $0xfff,%eax
8010726c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010726f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107275:	e8 c6 b6 ff ff       	call   80102940 <kalloc>
8010727a:	89 c3                	mov    %eax,%ebx
8010727c:	85 c0                	test   %eax,%eax
8010727e:	74 64                	je     801072e4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107280:	83 ec 04             	sub    $0x4,%esp
80107283:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107289:	68 00 10 00 00       	push   $0x1000
8010728e:	57                   	push   %edi
8010728f:	50                   	push   %eax
80107290:	e8 2b d7 ff ff       	call   801049c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107295:	58                   	pop    %eax
80107296:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010729c:	5a                   	pop    %edx
8010729d:	ff 75 e4             	push   -0x1c(%ebp)
801072a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072a5:	89 f2                	mov    %esi,%edx
801072a7:	50                   	push   %eax
801072a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ab:	e8 60 f8 ff ff       	call   80106b10 <mappages>
801072b0:	83 c4 10             	add    $0x10,%esp
801072b3:	85 c0                	test   %eax,%eax
801072b5:	78 21                	js     801072d8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801072b7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072bd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072c0:	0f 87 5a ff ff ff    	ja     80107220 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801072c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072cc:	5b                   	pop    %ebx
801072cd:	5e                   	pop    %esi
801072ce:	5f                   	pop    %edi
801072cf:	5d                   	pop    %ebp
801072d0:	c3                   	ret    
801072d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072d8:	83 ec 0c             	sub    $0xc,%esp
801072db:	53                   	push   %ebx
801072dc:	e8 9f b4 ff ff       	call   80102780 <kfree>
      goto bad;
801072e1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801072e4:	83 ec 0c             	sub    $0xc,%esp
801072e7:	ff 75 e0             	push   -0x20(%ebp)
801072ea:	e8 91 fd ff ff       	call   80107080 <freevm>
  return 0;
801072ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801072f6:	83 c4 10             	add    $0x10,%esp
}
801072f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ff:	5b                   	pop    %ebx
80107300:	5e                   	pop    %esi
80107301:	5f                   	pop    %edi
80107302:	5d                   	pop    %ebp
80107303:	c3                   	ret    
      panic("copyuvm: page not present");
80107304:	83 ec 0c             	sub    $0xc,%esp
80107307:	68 2e 7e 10 80       	push   $0x80107e2e
8010730c:	e8 6f 90 ff ff       	call   80100380 <panic>
80107311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731f:	90                   	nop

80107320 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107326:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107329:	89 c1                	mov    %eax,%ecx
8010732b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010732e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107331:	f6 c2 01             	test   $0x1,%dl
80107334:	0f 84 00 01 00 00    	je     8010743a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010733a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010733d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107343:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107344:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107349:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107350:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107352:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107357:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010735a:	05 00 00 00 80       	add    $0x80000000,%eax
8010735f:	83 fa 05             	cmp    $0x5,%edx
80107362:	ba 00 00 00 00       	mov    $0x0,%edx
80107367:	0f 45 c2             	cmovne %edx,%eax
}
8010736a:	c3                   	ret    
8010736b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop

80107370 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 0c             	sub    $0xc,%esp
80107379:	8b 75 14             	mov    0x14(%ebp),%esi
8010737c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010737f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107382:	85 f6                	test   %esi,%esi
80107384:	75 51                	jne    801073d7 <copyout+0x67>
80107386:	e9 a5 00 00 00       	jmp    80107430 <copyout+0xc0>
8010738b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010738f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107390:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107396:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010739c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801073a2:	74 75                	je     80107419 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801073a4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073a6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801073a9:	29 c3                	sub    %eax,%ebx
801073ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073b1:	39 f3                	cmp    %esi,%ebx
801073b3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801073b6:	29 f8                	sub    %edi,%eax
801073b8:	83 ec 04             	sub    $0x4,%esp
801073bb:	01 c1                	add    %eax,%ecx
801073bd:	53                   	push   %ebx
801073be:	52                   	push   %edx
801073bf:	51                   	push   %ecx
801073c0:	e8 fb d5 ff ff       	call   801049c0 <memmove>
    len -= n;
    buf += n;
801073c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801073c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801073ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801073d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801073d3:	29 de                	sub    %ebx,%esi
801073d5:	74 59                	je     80107430 <copyout+0xc0>
  if(*pde & PTE_P){
801073d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801073da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801073dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801073de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801073e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801073e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801073ea:	f6 c1 01             	test   $0x1,%cl
801073ed:	0f 84 4e 00 00 00    	je     80107441 <copyout.cold>
  return &pgtab[PTX(va)];
801073f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073fb:	c1 eb 0c             	shr    $0xc,%ebx
801073fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107404:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010740b:	89 d9                	mov    %ebx,%ecx
8010740d:	83 e1 05             	and    $0x5,%ecx
80107410:	83 f9 05             	cmp    $0x5,%ecx
80107413:	0f 84 77 ff ff ff    	je     80107390 <copyout+0x20>
  }
  return 0;
}
80107419:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010741c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107421:	5b                   	pop    %ebx
80107422:	5e                   	pop    %esi
80107423:	5f                   	pop    %edi
80107424:	5d                   	pop    %ebp
80107425:	c3                   	ret    
80107426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742d:	8d 76 00             	lea    0x0(%esi),%esi
80107430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107433:	31 c0                	xor    %eax,%eax
}
80107435:	5b                   	pop    %ebx
80107436:	5e                   	pop    %esi
80107437:	5f                   	pop    %edi
80107438:	5d                   	pop    %ebp
80107439:	c3                   	ret    

8010743a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010743a:	a1 00 00 00 00       	mov    0x0,%eax
8010743f:	0f 0b                	ud2    

80107441 <copyout.cold>:
80107441:	a1 00 00 00 00       	mov    0x0,%eax
80107446:	0f 0b                	ud2    
