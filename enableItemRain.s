.include "macros.s"

# The code below initializes values accessed by following code. Must assemble this when using with TCPGecko.
# WRITE 0x11000000
# .long 4
# .float 512
# .float 15
# .float 13.3333333333
# .float 2.5
# ENDWRITE

# Patch responsible for spawning the items.
# Assembled from C code. Source: "misc/ItemRain.c"
HOOK 0x0E5D41F0
fun_0e5d41f0:
stwu %r1,-16(%r1)
mflr %r0
stw %r0,20(%r1)
or %r31,%r5,%r5
bl patch_code
lwz %r3,0x4(%r30)
lwz %r0,20(%r1)
mtlr %r0
addi %r1,%r1,16
blr
patch_code:
stwu %r1,-112(%r1)
mflr %r0
stw %r0,116(%r1)
stw %r27,60(%r1)
stw %r28,64(%r1)
stw %r29,68(%r1)
stw %r30,72(%r1)
stw %r31,76(%r1)
lwz %r30,4(%r30)
lwz %r27,36(%r30)
lis %r9,0x1068
ori %r9,%r9,0xa71c
lwz %r29,0(%r9)
lwz %r9,224(%r27)
lwz %r28,32(%r9)
mr %r3,%r30
lis %r9,0xe31
ori %r9,%r9,0x419c
mtctr %r9
bctrl
mr %r31,%r3
mr %r4,%r3
mr %r3,%r29
lis %r9,0xe29
ori %r9,%r9,0x924c
mtctr %r9
bctrl
cmpwi %cr0,%r3,0
beq- %cr0,.L4
cmpwi %cr0,%r31,0
bne- %cr0,.L3
.L4:
lis %r9,0xe5c
ori %r9,%r9,0x171c
mtctr %r9
bctrl
cmpwi %cr0,%r3,0
beq- %cr0,.L6
cmpwi %cr0,%r31,-1
beq- %cr0,.L6
lis %r9,0x1068
ori %r9,%r9,0x3000
lwz %r9,0(%r9)
lwz %r7,604(%r9)
lis %r9,0x1100
stw %r7,68(%r9)
lbz %r9,72(%r9)
cmpwi %cr0,%r9,0
bne- %cr0,.L7
lis %r9,0x1100
li %r10,1
stb %r10,72(%r9)
li %r10,0
b .L8
.L9:
lis %r9,0x1100
lwz %r8,0(%r9)
mullw %r8,%r8,%r10
addi %r9,%r10,4
slwi %r9,%r9,2
addis %r9,%r9,0x1100
stw %r8,4(%r9)
addi %r10,%r10,1
.L8:
cmplw %cr0,%r7,%r10
bgt+ %cr0,.L9
.L7:
addi %r9,%r31,4
slwi %r9,%r9,2
addis %r9,%r9,0x1100
lwz %r9,4(%r9)
cmpwi %cr0,%r9,0
beq- %cr0,.L10
addi %r31,%r31,4
slwi %r31,%r31,2
addis %r31,%r31,0x1100
addi %r9,%r9,-1
stw %r9,4(%r31)
b .L3
.L10:
stw %r24,48(%r1)
stw %r25,52(%r1)
stw %r26,56(%r1)
stfd %f28,80(%r1)
stfd %f29,88(%r1)
stfd %f30,96(%r1)
stfd %f31,104(%r1)
lis %r24,0x1100
lwz %r9,0(%r24)
mullw %r7,%r7,%r9
addi %r7,%r7,-1
addi %r31,%r31,4
slwi %r31,%r31,2
addis %r31,%r31,0x1100
stw %r7,4(%r31)
mr %r3,%r27
lis %r9,0xe35
ori %r9,%r9,0x845c
mtctr %r9
bctrl
mr %r27,%r3
mr %r3,%r30
lis %r9,0xe31
ori %r9,%r9,0x4218
mtctr %r9
bctrl
mr %r26,%r3
mr %r3,%r30
lis %r9,0xe31
ori %r9,%r9,0x42f8
mtctr %r9
bctrl
mr %r25,%r3
mr %r3,%r30
lis %r9,0xe31
ori %r9,%r9,0x42c8
mtctr %r9
bctrl
fmr %f28,%f1
lfs %f29,4(%r24)
mr %r3,%r30
lis %r9,0xe31
ori %r9,%r9,0x4394
mtctr %r9
bctrl
cmpwi %cr0,%r3,0
beq- %cr0,.L11
lis %r9,0x1100
lfs %f0,16(%r9)
fdivs %f29,%f29,%f0
.L11:
li %r30,0
b .L12
.L13:
slwi %r9,%r30,2
lfsx %f0,%r26,%r9
addi %r10,%r1,8
add %r31,%r10,%r9
stfs %f0,12(%r31)
lfsx %f12,%r27,%r9
fmuls %f12,%f12,%f29
fsubs %f0,%f0,%f12
stfs %f0,12(%r31)
lfsx %f31,%r25,%r9
fmuls %f31,%f31,%f28
fadds %f30,%f29,%f29
lis %r9,0x1100
lfs %f1,12(%r9)
fdivs %f1,%f30,%f1
lis %r9,0xec0
ori %r9,%r9,0xb6a4
mtctr %r9
bctrl
fmuls %f31,%f31,%f1
lfs %f0,12(%r31)
fadds %f0,%f0,%f31
stfs %f0,12(%r31)
fmr %f1,%f30
lis %r9,0xea8
ori %r9,%r9,0x1f9c
mtctr %r9
bctrl
fsubs %f12,%f1,%f29
lfs %f0,12(%r31)
fadds %f0,%f0,%f12
stfs %f0,12(%r31)
addi %r30,%r30,1
.L12:
cmpwi %cr0,%r30,2
ble+ %cr0,.L13
li %r9,0
stw %r9,8(%r1)
stw %r9,12(%r1)
stw %r9,16(%r1)
lis %r9,0x1100
lfs %f1,8(%r9)
li %r7,2
addi %r6,%r1,8
addi %r5,%r1,20
mr %r4,%r28
mr %r3,%r29
lis %r9,0xe29
ori %r9,%r9,0xd9b8
mtctr %r9
bctrl
isync
lfd %f28,80(%r1)
lfd %f29,88(%r1)
lfd %f30,96(%r1)
lfd %f31,104(%r1)
lwz %r24,48(%r1)
lwz %r25,52(%r1)
lwz %r26,56(%r1)
b .L3
.L6:
lis %r9,0x1100
li %r10,0
stb %r10,72(%r9)
.L3:
lwz %r0,116(%r1)
mtlr %r0
lwz %r27,60(%r1)
lwz %r28,64(%r1)
lwz %r29,68(%r1)
lwz %r30,72(%r1)
lwz %r31,76(%r1)
addi %r1,%r1,112
blr
ENDHOOK

# Write condensed Item Probabilities to table (see https://www.mariowiki.com/Mario_Kart_8_item_probability_distributions#Special_purpose_(S3))
WRITE 0x0E2E8B28 
li %r3, 45		# Single banana probability
blr
li %r3, 45		# Single green probability
blr 
li %r3, 45		# Single red probability
blr 
li %r3, 11		# Single shroom probability
blr 
li %r3, 26		# Bob-omb probability
blr 
li %r3, 0		# Blooper probability
blr 
li %r3, 0		# Blue probability
blr 
li %r3, 0		# Triple shroom probability
blr 
li %r3, 4		# Star probability
blr 
li %r3, 0		# Bullet probability
blr 
li %r3, 0		# Lightning probability
blr 
li %r3, 0		# Golden probability
blr 
li %r3, 24		# Fire probability
blr 
li %r3, 0		# Piranha probability
blr
li %r3, 0		# Boomer probability
blr 
li %r3, 0		# Coin probability
blr 
li %r3, 0		# SHorn probability
blr 
ENDWRITE
