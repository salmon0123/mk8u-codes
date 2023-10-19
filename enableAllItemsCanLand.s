.include "macros.s"

# Write expanded Item Probabilities to table (see https://www.mariowiki.com/Mario_Kart_8_item_probability_distributions#Special_purpose_(S3))
WRITE 0x0E2E8B28
li %r3, 38		# Single banana probability
blr
li %r3, 38		# Single green probability
blr
li %r3, 38		# Single red probability
blr
li %r3, 9		# Single shroom probability
blr
li %r3, 22		# Bob-omb probability
blr
li %r3, 14		# Blooper probability
blr
li %r3, 4		# Blue probability
blr
li %r3, 0		# Triple shroom probability
blr
li %r3, 3		# Star probability
blr
li %r3, 3		# Bullet probability
blr
li %r3, 3		# Lightning probability
blr
li %r3, 3		# Golden probability
blr
li %r3, 20		# Fire probability
blr
li %r3, 5		# Piranha probability
blr
li %r3, 0		# Boomer probability
blr
li %r3, 0		# Coin probability
blr
li %r3, 0		# SHorn probability
blr
ENDWRITE

# convert ItemType to ItemSlot (uses DAT_10015234, supports all items for ItemObjDirectorBase::entry)
# Item       #Type   #Slot
# Green      0x0     0x1
# Red        0x1     0x2
# Banana     0x2     0x0
# Mushroom   0x3     0x3
# Star       0x4     0x8
# Blue       0x5     0x6
# Lightning  0x6     0xA
# Coin       0x7     0xF
# Golden     0x8     0xB
# Bob-Omb    0x9     0x4
# Blooper    0xA     0x5
# SHorn      0xB     0x10
# Bullet     0xC     0x9
# Fire       0xD     0xC
# Piranha    0xE     0xD
# Eight      0xF     0x14
# Boomerang  0x10    0xE
# Triple M           0x7
# Triple B           0x11
# Triple G           0x12
# Triple R           0x13
HOOK 0x0E29F524
lis %r3, 0x1051
ori %r3, %r3, 0x7434
lwz %r6, 0x8C(%r1)
lbzx %r6, %r3, %r6
blr
ENDHOOK

# allow blues to throw when touch
HOOK 0x0E29F548
li %r5, 0
lwz %r7,0x8C(%r1)
cmpwi %r7,0x5
bnelr
li %r5, 0x1
blr
ENDHOOK

# allow equip if star, shock, blooper, bullet, or piranha
HOOK 0x0E29F4D0
cmpwi %r10, 0x4
beqlr
cmpwi %r10, 0x5
beqlr
cmpwi %r10, 0x6
beqlr
cmpwi %r10, 0xC
beqlr
cmpwi %r10, 0xE
blr
ENDHOOK

# equip items even if star is equipped
HOOK 0x0E29EAE4
cmpwi %r28, 0xE
beqlr
cmpwi %r28, 0xC
beqlr
cmpwi %r28, 0x8
beqlr
cmpwi %r28, 0x6
blr
ENDHOOK

# throw blues
WRITEADDR 0x0E29EF68, "b 0x4d4"

# startDashKinoko with golden mushroom
WRITEADDR 0x0E29EC4C, "b 0x710"

# patches to allow piranha to be equipped, spoof star
HOOK 0x0E29E784
lwz %r7, 0x168(%r30)
cmpwi %r7, 0xE
bne skip
lwz %r12, 0x0 (%r29)
lbz %r0, 0x2d (%r12)
xori %r0, %r0, 0x5
cntlzw %r0, %r0
rlwinm %r7, %r0, 0x1b, 0x5, 0x1f
cmpwi %r7, 0x1
bne skip
li %r6, 0
li %r28, 0x4
li %r19, 0x0
li %r0, 0x0
rlwinm %r6, %r6, 0x0, 0x18, 0x1F
mflr %r12
addi %r12, %r12, 28
mtlr %r12
skip:
cmpwi %r23, 0x0
blr
ENDHOOK

# item function calls
HOOK 0x0E29F550
# ui:SettleItem(signed_char,_int)
# object::ItemSlot::start(object::eItemSlot)
# object::ItemOwnerProxy::clearItem()
# object::ItemOwnerProxy::_setStockItem(object::eItemSlot)
# object::ItemDirector::startKeepItem(object::eItemSlot,_object::ItemOwnerProxy_*)
# object::ItemDirector::keepToActivateItem(object::eItemSlot,_object::ItemOwnerProxy_*)
# object::ItemDirector::useStockItem(object::eItemSlot,_object::ItemOwnerProxy_*)

.set startSlot, 0x0E2E6594
.set SettleItem, 0x0E6E7360
.set clearItem, 0x0E2E3AC4
.set _setStockItem, 0x0E2E44A4
.set startKeepItem, 0x0E29E164
.set keepToActivateItem, 0x0E2998F4
.set useStockItem, 0x0E299824

mflr %r0
stw %r0, 0x8c (%r1)
lwz %r7, 0x90 (%r1)
cmpwi %r7, 0xD
beq next
cmpwi %r7, 0x9
bne end

next:
lwz %r4, 0x760 (%r22)
rlwinm %r3, %r25, 0x2, 0x0, 0x1d
lwzx %r30, %r3, %r4	                # ItemOwnerProxy * in r30

mr %r3, %r30
CALL clearItem

mr %r3, %r30
#lwz r3, 0x3c (r22)                  # ItemSlot *
addi %r4, %r1, 0x90	                # eItemSlot
#CALL startSlot
CALL _setStockItem

mr %r5, %r30
lwz %r4, 0x34 (%r5)
lwz %r3, 0x90 (%r1)                   # ItemID
CALL SettleItem

mr %r5, %r30
addi %r4, %r1, 0x90	                # eItemSlot
mr %r3, %r22		                    # ItemDirector *
CALL startKeepItem

mr %r5, %r30
addi %r4, %r1, 0x90	                # eItemSlot
mr %r3, %r22	                    # ItemDirector *
CALL keepToActivateItem

mr %r5, %r30
addi %r4, %r1, 0x90	                # eItemSlot
mr %r3, %r22		                    # ItemDirector *
CALL useStockItem
b finish

end:
bctrl                               # ItemObjDirectorBase::entry

finish:
lwz %r0, 0x8c (%r1)
mtlr %r0
blr
ENDHOOK

# allows picking up boxes in bullet
WRITEADDR 0x0E2C87F8, "nop"

# disable throwing animation online
WRITEADDR 0x0E56E3C8, "nop"

# allow player to get boxes every time
WRITEADDR 0x0E29D5F4, "nop"

# item limiters
WRITEADDR 0x0E2E9428, "li %r11, 7"          # star
WRITEADDR 0x0E2E9430, "li %r11, 7"          # bullet
WRITEADDR 0x0E2E9438, "li %r11, 7"          # golden
WRITEADDR 0x0E2E947C, "li %r11, 7"          # blue, piranha, eight

# patch item vtables
WRITEADDR 0x1051E8BC, ".long 0x0E2E0318"    # lightning HitGnd
WRITEADDR 0x1051E8C4, ".long 0x0E2E03E4"    # lightning HitWall
WRITEADDR 0x1051EA94, ".long 0x0E2E04E4"    # lightning stateSelfMove
WRITEADDR 0x1051A5D4, ".long 0x0E2E04E4"    # blooper stateSelfMove
WRITEADDR 0x1051AA34, ".long 0x0E2E0318"    # bullet HitGnd
WRITEADDR 0x1051AA3C, ".long 0x0E2E03E4"    # bullet HitWall
WRITEADDR 0x1051AC0C, ".long 0x0E2E04E4"    # bullet stateSelfMove
WRITEADDR 0x1051D544, ".long 0x0E2E0318"    # packun HitGnd
WRITEADDR 0x1051D54C, ".long 0x0E2E03E4"    # packun HitWall
WRITEADDR 0x1051D71C, ".long 0x0E2E04E4"    # packun stateSelfMove
