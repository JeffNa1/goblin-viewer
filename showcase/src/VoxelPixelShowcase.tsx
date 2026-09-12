import React from 'react';
import {
  AbsoluteFill,
  OffthreadVideo,
  staticFile,
  useCurrentFrame,
} from 'remotion';
import { loadFont as loadPressStart } from '@remotion/google-fonts/PressStart2P';
import { loadFont as loadSilkscreen } from '@remotion/google-fonts/Silkscreen';

const { fontFamily: pixelHeaderFont } = loadPressStart();
const { fontFamily: pixelBodyFont } = loadSilkscreen();

interface MonsterDataConfig {
  name: string;
  role: string;
  themeColor: string;
  accentColor: string;
  outfit: {
    badge: string;
    name: string;
    gear: string;
    isUpgraded: boolean;
  };
  anim: {
    type: string;
    name: string;
    detail: string;
  };
  stats: {
    hp: number;
    atk: number;
    def: number;
    spd: number;
  };
}

export const VoxelPixelShowcase: React.FC = () => {
  const frame = useCurrentFrame();

  let data: MonsterDataConfig;
  let isArcherAiming = false;

  if (frame < 240) {
    // 1. WARRIOR (0 - 240)
    const localF = frame;
    const isOutfit2 = localF >= 120;

    data = {
      name: 'GOBLIN WARRIOR',
      role: 'CLASS: FRONT-LINE BRAWLER // VANGUARD',
      themeColor: '#f97316',
      accentColor: '#fde047',
      outfit: isOutfit2
        ? {
            badge: 'OUTFIT 02 // UPGRADED',
            name: 'IRONCLAD VANGUARD',
            gear: 'HORNED STEEL HELMET • RIVETED ARMOR • HEAVY WAR-HAMMER',
            isUpgraded: true,
          }
        : {
            badge: 'OUTFIT 01 // ORIGINAL',
            name: 'PRIMITIVE BRAWLER',
            gear: 'RAGGED HIDE KILT • WRAPPED GUARDS • SPIKED CLUB',
            isUpgraded: false,
          },
      anim: !isOutfit2
        ? localF < 60
          ? {
              type: 'STANCE',
              name: 'COMBAT IDLE',
              detail: 'BALANCED DEFENSE & CONTROLLED BREATHING',
            }
          : {
              type: 'MOVEMENT',
              name: 'MARCHING WALK',
              detail: 'PROCEDURAL SKELETAL INVERSE KINEMATICS',
            }
        : localF < 150
        ? {
            type: 'EQUIP',
            name: 'BATTLE READY',
            detail: 'FULL IRON ARMOR & SPIKED MACE DEPLOYED',
          }
        : {
            type: 'ACTION',
            name: 'SKULLCRUSHER SMASH',
            detail: 'TWO-HANDED HEAVY BLUNT OVERHAND SLAM',
          },
      stats: { hp: 75, atk: 70, def: 60, spd: 45 },
    };
  } else if (frame < 540) {
    // 2. ARCHER (240 - 540)
    const localF = frame - 240;
    const isOutfit2 = localF >= 120;
    isArcherAiming = localF >= 120 && localF < 195;

    data = {
      name: 'GOBLIN ARCHER',
      role: 'CLASS: CANOPY MARKSMAN // SNIPER',
      themeColor: '#22c55e',
      accentColor: '#86efac',
      outfit: isOutfit2
        ? {
            badge: 'OUTFIT 02 // UPGRADED',
            name: 'RANGER SPECIALIST',
            gear: 'FEATHERED CAP • CAMO TUNIC • CURVED YEW BOW • BARBED QUIVER',
            isUpgraded: true,
          }
        : {
            badge: 'OUTFIT 01 // ORIGINAL',
            name: 'PRIMITIVE HUNTER',
            gear: 'MOTTLED TUNIC • SHORT RECURVE BOW • BONE TIPS',
            isUpgraded: false,
          },
      anim: !isOutfit2
        ? localF < 60
          ? {
              type: 'STANCE',
              name: 'SCOUT IDLE',
              detail: 'CANOPY VANTAGE WATCH & STEADY EYE',
            }
          : {
              type: 'MOVEMENT',
              name: 'SCOUT WALK CYCLE',
              detail: 'SILENT AMBUSH PATROL THROUGH BRUSH',
            }
        : localF < 195
        ? {
            type: 'ACTION',
            name: 'BOW DRAW & AIM',
            detail: 'TENSIONED BOWSTRING • PRECISION TARGET LOCK',
          }
        : {
            type: 'ACTION',
            name: 'PIERCING ARROW SHOT',
            detail: 'INSTANT STRING RELEASE WITH REALISTIC RECOIL',
          },
      stats: { hp: 45, atk: 80, def: 35, spd: 88 },
    };
  } else if (frame < 840) {
    // 3. SHAMAN (540 - 840)
    const localF = frame - 540;
    const isOutfit2 = localF >= 120;

    data = {
      name: 'GOBLIN SHAMAN',
      role: 'CLASS: VOID CALLER // ARCH-MAGE',
      themeColor: '#a855f7',
      accentColor: '#f0abfc',
      outfit: isOutfit2
        ? {
            badge: 'OUTFIT 02 // UPGRADED',
            name: 'GRAND ARCH-SHAMAN',
            gear: 'BILLOWING 3D CLOTH CAPE • RUNIC ANTLER STAFF',
            isUpgraded: true,
          }
        : {
            badge: 'OUTFIT 01 // ORIGINAL',
            name: 'WITCH DOCTOR',
            gear: 'BEAST SKULL MASK • BONE AMULET • CARVED EFFIGY',
            isUpgraded: false,
          },
      anim: !isOutfit2
        ? localF < 60
          ? {
              type: 'STANCE',
              name: 'OCCULT IDLE',
              detail: 'MEDITATIVE TRANCE & SPIRIT CHANNELING',
            }
          : {
              type: 'MOVEMENT',
              name: 'PROCEDURAL RITUAL WALK',
              detail: 'SWAYING VOID STRIDE ACROSS MEADOW',
            }
        : localF < 165
        ? {
            type: 'INSPECTION',
            name: '3D CLOAK MOTION',
            detail: 'DYNAMIC PROCEDURAL CLOTH SIMULATION',
          }
        : localF < 240
        ? {
            type: 'ACTION',
            name: 'BLOODCURSE CHANT',
            detail: 'STAFF ELEVATION & ANCESTRAL INCANTATION',
          }
        : {
            type: 'ACTION',
            name: 'TOTEM SUMMONING',
            detail: 'GROUND IMPACT INVOKING SPIRIT EFFIGY',
          },
      stats: { hp: 55, atk: 90, def: 40, spd: 60 },
    };
  } else if (frame < 1140) {
    // 4. ROGUE (840 - 1140)
    const localF = frame - 840;
    const isOutfit2 = localF >= 120;

    data = {
      name: 'GOBLIN ROGUE',
      role: 'CLASS: SHADOW VIPER // INFILTRATOR',
      themeColor: '#06b6d4',
      accentColor: '#a5f3fc',
      outfit: isOutfit2
        ? {
            badge: 'OUTFIT 02 // UPGRADED',
            name: 'SHADOW ASSASSIN',
            gear: 'STEALTH HOOD & COWL • DUAL OBSIDIAN BLADES',
            isUpgraded: true,
          }
        : {
            badge: 'OUTFIT 01 // ORIGINAL',
            name: 'PRIMITIVE SCAVENGER',
            gear: 'TATTERED CLOTH • FLINT DAGGERS • PADDED WRAPS',
            isUpgraded: false,
          },
      anim: !isOutfit2
        ? localF < 60
          ? {
              type: 'STANCE',
              name: 'REVERSE DAGGER IDLE',
              detail: 'LOW-PROFILE CROUCH WITH BLADES CONCEALED',
            }
          : {
              type: 'MOVEMENT',
              name: 'SNEAK WALK CYCLE',
              detail: 'ZERO-SOUND CREEPING FLANK APPROACH',
            }
        : localF < 165
        ? {
            type: 'EQUIP',
            name: 'TWIN OBSIDIAN BLADES',
            detail: 'DUAL RAZOR-SHARP SERRATED EDGES ARMED',
          }
        : localF < 240
        ? {
            type: 'ACTION',
            name: 'DUAL SLASH X-COMBO',
            detail: 'CROSS-CUTTING HIGH-SPEED EXECUTION SLICE',
          }
        : {
            type: 'MOVEMENT',
            name: 'SCURRY SPRINT',
            detail: 'AGILE LOW-TRAJECTORY EVASION DASH',
          },
      stats: { hp: 50, atk: 92, def: 42, spd: 95 },
    };
  } else {
    // 5. MACE OGRE (1140 - 1440) - NO WORLD BOSS LABEL, MOVEMENT ONLY!
    const localF = frame - 1140;
    const isMoving = localF >= 150;

    data = {
      name: 'MACE OGRE',
      role: 'CLASS: PRIMAL COLOSSUS // TITAN',
      themeColor: '#ef4444',
      accentColor: '#fca5a5',
      outfit: {
        badge: 'NEW 3D REBUILT MODEL',
        name: 'PRIMITIVE BONE & HIDE',
        gear: '51,468 VOXELS • 16-FLANGED MACE • 0 CHECKERBOARD ARTIFACTS',
        isUpgraded: true,
      },
      anim: !isMoving
        ? {
            type: '360° INSPECTION',
            name: 'COLOSSAL TURNTABLE IDLE',
            detail: 'ORGANIC MUSCULAR VOXEL ANATOMY & WAR MACE',
          }
        : {
            type: 'MOVEMENT',
            name: 'HEAVY TITAN WALK CYCLE',
            detail: 'EARTH-QUAKING STOMP FOOTSTEPS OF THE COLOSSUS',
          },
      stats: { hp: 100, atk: 98, def: 92, spd: 40 },
    };
  }

  // Flash when switching outfits
  const isOutfitSwitch =
    (frame >= 118 && frame <= 124) ||
    (frame >= 358 && frame <= 364) ||
    (frame >= 658 && frame <= 664) ||
    (frame >= 958 && frame <= 964);

  // Render 10 discrete pixel pips for stat bars
  const renderPixelStatBar = (label: string, value: number, color: string) => {
    const totalPips = 10;
    const activePips = Math.round((value / 100) * totalPips);

    return (
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '12px',
          fontFamily: pixelBodyFont,
          fontSize: '14px',
          fontWeight: 700,
        }}
      >
        <span style={{ width: '40px', color: '#cbd5e1' }}>{label}</span>
        <div style={{ display: 'flex', gap: '3px' }}>
          {Array.from({ length: totalPips }).map((_, idx) => {
            const isFilled = idx < activePips;
            return (
              <div
                key={idx}
                style={{
                  width: '18px',
                  height: '14px',
                  backgroundColor: isFilled ? color : '#1e293b',
                  border: '2px solid #000000',
                  boxShadow: isFilled ? `inset 1px 1px 0px rgba(255,255,255,0.4)` : 'none',
                }}
              />
            );
          })}
        </div>
        <span style={{ width: '36px', textAlign: 'right', color: color, fontWeight: 900 }}>
          {value}
        </span>
      </div>
    );
  };

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#000000',
        overflow: 'hidden',
      }}
    >
      {/* 1. In-Engine Clean 3D Video Footage */}
      <OffthreadVideo
        src={staticFile('assets/clean_footage.mp4')}
        style={{
          width: '100%',
          height: '100%',
          objectFit: 'cover',
        }}
      />

      {/* Outfit Switch Flash */}
      {isOutfitSwitch && (
        <div
          style={{
            position: 'absolute',
            inset: 0,
            backgroundColor: '#ffffff',
            opacity: 0.35,
            pointerEvents: 'none',
          }}
        />
      )}

      {/* 2. PIXELATED ARCHER CROSSHAIR (Stepped Retro Pixel Art Reticle) */}
      {isArcherAiming && (
        <div
          style={{
            position: 'absolute',
            top: '46%',
            left: '50%',
            translate: '-50% -50%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '12px',
            pointerEvents: 'none',
          }}
        >
          {/* Pixel Crosshair Box */}
          <div
            style={{
              width: '100px',
              height: '100px',
              position: 'relative',
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            {/* 4 Corner Stepped Pixel Brackets */}
            <div
              style={{
                position: 'absolute',
                top: 0,
                left: 0,
                width: '24px',
                height: '24px',
                borderTop: '4px solid #22c55e',
                borderLeft: '4px solid #22c55e',
              }}
            />
            <div
              style={{
                position: 'absolute',
                top: 0,
                right: 0,
                width: '24px',
                height: '24px',
                borderTop: '4px solid #22c55e',
                borderRight: '4px solid #22c55e',
              }}
            />
            <div
              style={{
                position: 'absolute',
                bottom: 0,
                left: 0,
                width: '24px',
                height: '24px',
                borderBottom: '4px solid #22c55e',
                borderLeft: '4px solid #22c55e',
              }}
            />
            <div
              style={{
                position: 'absolute',
                bottom: 0,
                right: 0,
                width: '24px',
                height: '24px',
                borderBottom: '4px solid #22c55e',
                borderRight: '4px solid #22c55e',
              }}
            />

            {/* Center Blinking Red Pixel Dot */}
            <div
              style={{
                width: '12px',
                height: '12px',
                backgroundColor: frame % 10 < 5 ? '#ef4444' : '#ffffff',
                border: '2px solid #000000',
              }}
            />
          </div>

          <div
            style={{
              fontFamily: pixelHeaderFont,
              fontSize: '11px',
              color: '#22c55e',
              backgroundColor: '#0a0d14',
              padding: '6px 12px',
              border: '3px solid #000000',
              boxShadow: 'inset 2px 2px 0px #384259, inset -2px -2px 0px #080a0f',
              letterSpacing: '1px',
            }}
          >
            [ TARGET LOCKED ]
          </div>
        </div>
      )}

      {/* 3. TOP PIXEL BAR: Header & Identification */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          height: '75px',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          padding: '0 40px',
          backgroundColor: '#0f121d',
          borderBottom: '4px solid #000000',
          boxShadow: 'inset 0 -3px 0 #283248, 0 6px 0 rgba(0,0,0,0.5)',
        }}
      >
        {/* Left: Monster Title in PressStart2P */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <div
            style={{
              width: '16px',
              height: '16px',
              backgroundColor: data.themeColor,
              border: '3px solid #000000',
            }}
          />
          <div>
            <div
              style={{
                fontFamily: pixelHeaderFont,
                fontSize: '22px',
                color: '#ffffff',
                letterSpacing: '1px',
                textShadow: `3px 3px 0px #000000, 0 0 10px ${data.themeColor}`,
                lineHeight: 1.2,
              }}
            >
              {data.name}
            </div>
            <div
              style={{
                fontFamily: pixelBodyFont,
                fontSize: '13px',
                color: data.themeColor,
                fontWeight: 700,
                letterSpacing: '1.5px',
                marginTop: '4px',
              }}
            >
              {data.role}
            </div>
          </div>
        </div>

        {/* Right: Engine Specs Badge */}
        <div
          style={{
            fontFamily: pixelBodyFont,
            fontSize: '13px',
            fontWeight: 700,
            color: '#fbbf24',
            backgroundColor: '#171b29',
            padding: '8px 16px',
            border: '3px solid #000000',
            boxShadow: 'inset 2px 2px 0px #384259, inset -2px -2px 0px #080a0f',
            letterSpacing: '1px',
          }}
        >
          [ GODOT 4.7 • PROCEDURAL VOXEL RIGS ]
        </div>
      </div>

      {/* 4. TOP-RIGHT PIXEL WINDOW: Wardrobe / Outfit Evolution */}
      <div
        style={{
          position: 'absolute',
          top: '95px',
          right: '40px',
          width: '420px',
          backgroundColor: '#121624',
          border: '4px solid #000000',
          boxShadow: `inset 2px 2px 0px #384259, inset -2px -2px 0px #080a0f, 0 8px 0 rgba(0,0,0,0.6)`,
          padding: '16px 20px',
          display: 'flex',
          flexDirection: 'column',
          gap: '8px',
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div
            style={{
              fontFamily: pixelHeaderFont,
              fontSize: '10px',
              color: data.outfit.isUpgraded ? data.accentColor : '#94a3b8',
              letterSpacing: '1px',
            }}
          >
            {data.outfit.badge}
          </div>
          {data.outfit.isUpgraded && (
            <div
              style={{
                fontFamily: pixelBodyFont,
                fontSize: '11px',
                fontWeight: 800,
                color: '#000000',
                backgroundColor: data.themeColor,
                padding: '2px 8px',
                border: '2px solid #000000',
              }}
            >
              EQUIPPED
            </div>
          )}
        </div>

        <div
          style={{
            fontFamily: pixelHeaderFont,
            fontSize: '14px',
            color: '#ffffff',
            lineHeight: 1.3,
            textShadow: '2px 2px 0px #000000',
          }}
        >
          {data.outfit.name}
        </div>

        <div
          style={{
            fontFamily: pixelBodyFont,
            fontSize: '13px',
            color: '#cbd5e1',
            lineHeight: 1.4,
            fontWeight: 600,
            borderTop: '2px dashed #263248',
            paddingTop: '8px',
          }}
        >
          {data.outfit.gear}
        </div>
      </div>

      {/* 5. BOTTOM-LEFT PIXEL WINDOW: Active Animation / Move Spotlight */}
      <div
        style={{
          position: 'absolute',
          bottom: '35px',
          left: '40px',
          width: '560px',
          backgroundColor: '#121624',
          border: '4px solid #000000',
          boxShadow: 'inset 2px 2px 0px #384259, inset -2px -2px 0px #080a0f, 0 8px 0 rgba(0,0,0,0.6)',
          padding: '18px 24px',
          display: 'flex',
          alignItems: 'center',
          gap: '20px',
        }}
      >
        {/* Pixel Icon Box */}
        <div
          style={{
            width: '56px',
            height: '56px',
            backgroundColor: '#0a0d16',
            border: `3px solid ${data.themeColor}`,
            boxShadow: 'inset 2px 2px 0px #000000',
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            flexShrink: 0,
            color: data.themeColor,
            fontFamily: pixelHeaderFont,
            fontSize: '18px',
          }}
        >
          {data.anim.type === 'ACTION' ? '⚔' : data.anim.type === 'MOVEMENT' ? '►' : '✦'}
        </div>

        {/* Action Info */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
          <div
            style={{
              fontFamily: pixelHeaderFont,
              fontSize: '10px',
              color: data.themeColor,
              letterSpacing: '1px',
            }}
          >
            [ {data.anim.type} ]
          </div>
          <div
            style={{
              fontFamily: pixelHeaderFont,
              fontSize: '16px',
              color: '#ffffff',
              lineHeight: 1.25,
              textShadow: '2px 2px 0px #000000',
            }}
          >
            {data.anim.name}
          </div>
          <div
            style={{
              fontFamily: pixelBodyFont,
              fontSize: '13px',
              color: '#94a3b8',
              fontWeight: 600,
              lineHeight: 1.3,
            }}
          >
            {data.anim.detail}
          </div>
        </div>
      </div>

      {/* 6. BOTTOM-RIGHT PIXEL WINDOW: Combat Attributes with Discrete Blocks */}
      <div
        style={{
          position: 'absolute',
          bottom: '35px',
          right: '40px',
          width: '400px',
          backgroundColor: '#121624',
          border: '4px solid #000000',
          boxShadow: 'inset 2px 2px 0px #384259, inset -2px -2px 0px #080a0f, 0 8px 0 rgba(0,0,0,0.6)',
          padding: '16px 22px',
          display: 'flex',
          flexDirection: 'column',
          gap: '8px',
        }}
      >
        <div
          style={{
            fontFamily: pixelHeaderFont,
            fontSize: '11px',
            color: '#fbbf24',
            letterSpacing: '1px',
            marginBottom: '4px',
          }}
        >
          [ COMBAT ATTRIBUTES ]
        </div>

        {renderPixelStatBar('HP', data.stats.hp, '#ef4444')}
        {renderPixelStatBar('ATK', data.stats.atk, '#f97316')}
        {renderPixelStatBar('DEF', data.stats.def, '#3b82f6')}
        {renderPixelStatBar('SPD', data.stats.spd, '#10b981')}
      </div>

      {/* 7. Subtle Retro Scanline Overlay (Optional arcade feel) */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          backgroundImage:
            'linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%)',
          backgroundSize: '100% 4px',
          pointerEvents: 'none',
          opacity: 0.45,
        }}
      />
    </AbsoluteFill>
  );
};
