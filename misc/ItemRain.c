// MK8 Item Rain (C Source)
// Assemble in Compiler Explorer
// PowerPC gcc 12.2.0
// Compiler Options: -Og -mregnames -mmultiple -mcpu=750

// Requires write to initialize values accessed via codeSettings

#include <stdint.h>
#include <stdbool.h>

struct settings {
    const uint32_t frameskip;       // default 4
    const float spawnDist;          // default 512
    const float emitArg;            // default 15
    const float gravity;            // default 13.3333333
    const float antiGravFactor;     // default 2.5
    uint32_t playerTimer[12];
    uint32_t playerNum;
    bool initialized;
};

void patch_code();

// hooks function that runs 12 times each frame for each player
void fun_0e5d41f0() {
    asm volatile("or %r31,%r5,%r5");
    patch();               // after assembling, need to rename label to 'patch_code'
    asm volatile("lwz %r3,0x4(%r30)");
}

void patch_code() {
    typedef bool func1();
    typedef bool func2(uint32_t* ItemDirector, uint32_t playerID);
    typedef int32_t func3(uint32_t* ptr);
    typedef float func4(float);
    typedef void func5(float* ptrToVec, float* ptrToResultVec);
    typedef void func6(float* ptrToResultVec, uint32_t* KartVehicleMove);
    typedef void func7(uint32_t* ItemDirector, uint32_t* KartVehicleReact, float* posVec, float* velVec, int, float);
    typedef uint32_t func8(uint32_t* KartInfoProxy);
    typedef float* func9(uint32_t* KartInfoProxy);
    typedef float func10(uint32_t* KartInfoProxy);
    typedef float* func11(uint32_t* KartVehicleMove);
    typedef bool func12(uint32_t* KartInfoProxy);
    
    func1* isRaceState = (func1*)0x0E5C171C;
    func2* isNetSend = (func2*)0x0E29924C;
    func3* getRandomU32 = (func3*)0x0E8C52F8;
    func4* fsqrt = (func4*)0x0EC0B6A4;
    func5* ASM_VECNormalize = (func5*)0x0E7F7A4C;
    func6* getGravity = (func6*)0x0E350584;
    func7* emitItem = (func7*)0x0E29D9B8;
    func8* getPlayerID = (func8*)0x0E31419C;
    func9* getPos = (func9*)0x0E314218;
    func9* getDriveDir = (func9*)0x0E3142F8;
    func10* getDriveSpd = (func10*)0x0E3142C8;
    func11* getGravityVec = (func11*)0x0E35845C;
    func4* getRandomFloat = (func4*)0x0EA81F9C;
    func12* isAntiG = (func12*)0x0E314394;

    // #define PLAYERNUM_DEBUG 2

    const uint32_t dataAddress = 0x11000000;
    struct settings* codeSettings = (struct settings*)dataAddress;

    register uint32_t* dummyPtr asm("%r30");
    uint32_t* KartInfoProxy = *((uint32_t**)(dummyPtr+0x4/4));
    uint32_t* KartVehicleMove = *((uint32_t**)(KartInfoProxy+0x24/4));
    uint32_t* ItemDirector = *((uint32_t**)0x1068A71C);
    uint32_t* KartVehicleReact = (uint32_t*)(*(*(uint32_t**)(KartVehicleMove+0xE0/4)+0x20/4));
    uint32_t playerID = getPlayerID(KartInfoProxy);

    if (isNetSend(ItemDirector, playerID) && (playerID != 0)) {
        return;
    }

    /* if (playerID >= PLAYERNUM_DEBUG) {
        return;
    }
    */

    if (isRaceState() && (playerID != -1)) {
        codeSettings->playerNum = *(*((uint32_t**)0x10683000)+0x25c/4);
        // codeSettings->playerNum = PLAYERNUM_DEBUG;             // test n-player behavior

        if (codeSettings->initialized == false) {
            codeSettings->initialized = true;                   // if first time in new race, initialize playerTimer array
            int i;
            for (i=0; i<codeSettings->playerNum; i++) {
                codeSettings->playerTimer[i] = i*codeSettings->frameskip;
            }
        }
        if (codeSettings->playerTimer[playerID] != 0) {
            codeSettings->playerTimer[playerID]--;              // decrement playerTimer as needed
        }
        else {
            codeSettings->playerTimer[playerID] = (codeSettings->playerNum)*codeSettings->frameskip - 1;    // reset playerTimer value

            float* gravityVecPtr = getGravityVec(KartVehicleMove);
            float* posVecPtr = getPos(KartInfoProxy);
            float* driveVecPtr = getDriveDir(KartInfoProxy);
            float driveSpd = getDriveSpd(KartInfoProxy);
            float base_height = codeSettings->spawnDist;            // set spawn distance

            if (isAntiG(KartInfoProxy)) {
                base_height /= codeSettings->antiGravFactor;                   // if the player is in an anti-gravity area, halve spawn distance
            }
            float spawnVec[3];

            int j;
            for (j=0; j<3; j++) {
                spawnVec[j] = *(posVecPtr+j);                                       // start with player position
                spawnVec[j] -= *(gravityVecPtr+j)*base_height;                      // add normal component (negative value)
                spawnVec[j] += *(driveVecPtr+j)*driveSpd*fsqrt(2*base_height/codeSettings->gravity);  // add approximation for v*sqrt(2h/g)
                //spawnVec[j] += *(driveVecPtr+j)*base_height;                        // cause more items to fall ahead of player
                float randFloat = getRandomFloat(2*base_height)-base_height;
                spawnVec[j] += randFloat;                                           // for random placement
            }

            float velVec[3] = {0};
            emitItem(ItemDirector, KartVehicleReact, spawnVec, velVec, 2, codeSettings->emitArg);
            asm("isync");
        }
    }
    else {
        codeSettings->initialized = false;
    }
}