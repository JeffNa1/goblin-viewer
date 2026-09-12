import React from 'react';
import {
  AbsoluteFill,
  OffthreadVideo,
  staticFile,
  useCurrentFrame,
  interpolate,
  Easing,
} from 'remotion';
import {
  Shield,
  Swords,
  Crosshair,
  Sparkles,
  Footprints,
  Flame,
  Shirt,
  Sparkle,
  Zap,
} from 'lucide-react';

interface MonsterSceneInfo {
  name: string;
  subname: string;
  themeColor: string;
  accentColor: string;
  outfit: {
    name: string;
    badge: string;
    desc: string;
    isUpgraded: boolean;
  };
  action: {
    title: string;
    subtitle: string;
    icon: string;
  };
  stats: {
    hp: number;
    atk: number;
    def: number;
    spd: number;
  };
}

export const PolishedShowcase: React.FC = () => {
  const frame = useCurrentFrame();

  // Determine active monster & state based on frame
  let scene: MonsterSceneInfo;
  let sceneProgress = 0; // 0 to 1 inside current scene
  let isArcherAiming = false;

  if (frame < 240) {
    // 1. WARRIOR (0 - 240)
    const localF = frame;
    sceneProgress = localF / 240;
    const isOutfit2 = localF >= 120;

    scene = {
      name: 'GOBLIN WARRIOR',
      subname: 'FRONTLINE VANGUARD • MELEE BRUISER',
      themeColor: '#f97316',
      accentColor: '#fdba74',
      outfit: isOutfit2
        ? {
            name: 'CHIẾN BINH THÉP (IRONCLAD)',
            badge: 'BỘ ĐỒ 2: NÂNG CẤP',
            desc: 'Mũ sừng chiến trận, đinh tán sắt và chùy chiến nặng',
            isUpgraded: true,
          }
        : {
            name: 'THÔ SƠ (PRIMITIVE BRAWLER)',
            badge: 'BỘ ĐỒ 1: NGUYÊN BẢN',
            desc: 'Da thú rách, quấn tay thô sơ và chùy gỗ gai',
            isUpgraded: false,
          },
      action: !isOutfit2
        ? localF < 60
          ? {
              title: 'COMBAT IDLE',
              subtitle: 'Dáng đứng thở & thủ thế cận chiến',
              icon: 'shield',
            }
          : {
              title: 'MARCHING WALK',
              subtitle: 'Bước tiến nhịp nhàng • Rig xương IK',
              icon: 'footprints',
            }
        : localF < 150
        ? {
            title: 'BATTLE STANCE',
            subtitle: 'Trang bị giáp sắt chiến binh',
            icon: 'shirt',
          }
        : {
            title: 'SKULLCRUSHER SMASH',
            subtitle: 'Vung chùy hai tay giáng đòn uy lực',
            icon: 'swords',
          },
      stats: { hp: 75, atk: 70, def: 60, spd: 45 },
    };
  } else if (frame < 540) {
    // 2. ARCHER (240 - 540)
    const localF = frame - 240;
    sceneProgress = localF / 300;
    const isOutfit2 = localF >= 120;
    isArcherAiming = localF >= 120 && localF < 195;

    scene = {
      name: 'GOBLIN ARCHER',
      subname: 'CANOPY MARKSMAN • RANGED SNIPER',
      themeColor: '#22c55e',
      accentColor: '#86efac',
      outfit: isOutfit2
        ? {
            name: 'XẠ THỦ KIỂM LÂM (RANGER)',
            badge: 'BỘ ĐỒ 2: NÂNG CẤP',
            desc: 'Mũ lông chim, áo choàng ngụy trang và ống tên gai',
            isUpgraded: true,
          }
        : {
            name: 'THỢ SĂN THÔ SƠ (PRIMITIVE HUNTER)',
            badge: 'BỘ ĐỒ 1: NGUYÊN BẢN',
            desc: 'Dây da đơn sơ và cung săn cơ bản',
            isUpgraded: false,
          },
      action: !isOutfit2
        ? localF < 60
          ? {
              title: 'SCOUT IDLE',
              subtitle: 'Thủ cung rình mồi trên cây ngọn',
              icon: 'shield',
            }
          : {
              title: 'SCOUT WALK CYCLE',
              subtitle: 'Di chuyển lướt nhẹ không tiếng động',
              icon: 'footprints',
            }
        : localF < 195
        ? {
            title: 'GIƯƠNG CUNG NGẮM BẮN (AIM & DRAW)',
            subtitle: 'Kéo căng dây cung, khóa mục tiêu chuẩn xác',
            icon: 'crosshair',
          }
        : {
            title: 'BẮN TÊN (PIERCING RELEASE)',
            subtitle: 'Thả tên sát thương cao với độ giật chân thực',
            icon: 'zap',
          },
      stats: { hp: 45, atk: 80, def: 35, spd: 88 },
    };
  } else if (frame < 840) {
    // 3. SHAMAN (540 - 840)
    const localF = frame - 540;
    sceneProgress = localF / 300;
    const isOutfit2 = localF >= 120;

    scene = {
      name: 'GOBLIN SHAMAN',
      subname: 'VOID CALLER • OCCULT ARCH-MAGE',
      themeColor: '#a855f7',
      accentColor: '#d8b4fe',
      outfit: isOutfit2
        ? {
            name: 'ĐẠI PHÁP SƯ (GRAND ARCH-SHAMAN)',
            badge: 'BỘ ĐỒ 2: NÂNG CẤP',
            desc: 'Áo choàng 3D tung bay, trượng gạc hươu triệu linh',
            isUpgraded: true,
          }
        : {
            name: 'THẦY PHÙ THỦY THÔ SƠ (WITCH DOCTOR)',
            badge: 'BỘ ĐỒ 1: NGUYÊN BẢN',
            desc: 'Mặt nạ xương thú và chuỗi hạt cổ xưa',
            isUpgraded: false,
          },
      action: !isOutfit2
        ? localF < 60
          ? {
              title: 'OCCULTIST IDLE',
              subtitle: 'Dáng đứng tĩnh lặng nghe tiếng thì thầm bóng tối',
              icon: 'sparkles',
            }
          : {
              title: 'PROCEDURAL WALK',
              subtitle: 'Bước đi huyền bí trên thảo nguyên',
              icon: 'footprints',
            }
        : localF < 165
        ? {
            title: '3D CLOAK INSPECTION',
            subtitle: 'Hiệu ứng áo choàng 3D uốn lượn theo gió',
            icon: 'shirt',
          }
        : localF < 240
        ? {
            title: 'RITUAL INCANTATION CHANT',
            subtitle: 'Đung đưa quyền trượng niệm chú triệu hồi',
            icon: 'sparkles',
          }
        : {
            title: 'TOTEM SUMMONING',
            subtitle: 'Cắm trượng giáng trụ linh hồn bảo hộ',
            icon: 'flame',
          },
      stats: { hp: 55, atk: 90, def: 40, spd: 60 },
    };
  } else if (frame < 1140) {
    // 4. ROGUE (840 - 1140)
    const localF = frame - 840;
    sceneProgress = localF / 300;
    const isOutfit2 = localF >= 120;

    scene = {
      name: 'GOBLIN ROGUE',
      subname: 'SHADOW INFILTRATOR • DUAL EXECUTIONER',
      themeColor: '#0ea5e9',
      accentColor: '#7dd3fc',
      outfit: isOutfit2
        ? {
            name: 'SÁT THỦ BÓNG ĐÊM (SHADOW ASSASSIN)',
            badge: 'BỘ ĐỒ 2: NÂNG CẤP',
            desc: 'Khăn trùm sát thủ, song đao obsidian sắc bén',
            isUpgraded: true,
          }
        : {
            name: 'KẺ LÉN LÚT THÔ SƠ (SCAVENGER)',
            badge: 'BỘ ĐỒ 1: NGUYÊN BẢN',
            desc: 'Quần áo rách thô sơ, dao găm đá đẽo',
            isUpgraded: false,
          },
      action: !isOutfit2
        ? localF < 60
          ? {
              title: 'REVERSE DAGGER IDLE',
              subtitle: 'Cầm ngược dao găm hạ thấp trọng tâm',
              icon: 'shield',
            }
          : {
              title: 'SNEAK WALK CYCLE',
              subtitle: 'Lẻn đi nhẹ nhàng áp sát con mồi',
              icon: 'footprints',
            }
        : localF < 165
        ? {
            title: 'ASSASSIN STANCE',
            subtitle: 'Trang bị cặp dao đen obsidian',
            icon: 'shirt',
          }
        : localF < 240
        ? {
            title: 'DUAL SLASH X-COMBO',
            subtitle: 'Combo chém chéo chữ X tốc độ chớp nhoáng',
            icon: 'swords',
          }
        : {
            title: 'SCURRY SPRINT',
            subtitle: 'Chạy nước rút luồn lách thoăn thoắt',
            icon: 'footprints',
          },
      stats: { hp: 50, atk: 92, def: 42, spd: 95 },
    };
  } else {
    // 5. MACE OGRE (1140 - 1440) - NO WORLD BOSS LABEL, MOVEMENT & IDLE ONLY!
    const localF = frame - 1140;
    sceneProgress = localF / 300;
    const isMoving = localF >= 150;

    scene = {
      name: 'MACE OGRE',
      subname: 'PRIMAL COLOSSUS • TITAN OF RUIN',
      themeColor: '#ef4444',
      accentColor: '#fca5a5',
      outfit: {
        name: 'PRIMITIVE BONE & LEATHER',
        badge: 'NEW 3D REBUILT MODEL',
        desc: '51,468 Voxels • Cơ bắp thô sơ • Chùy gai 16 cánh (0 hạt caro)',
        isUpgraded: true,
      },
      action: !isMoving
        ? {
            title: '360° TURNTABLE INSPECTION',
            subtitle: 'Xoay tròn ngắm cơ bắp, khố da & chùy gai 16 cánh',
            icon: 'shield',
          }
        : {
            title: 'HEAVY TITAN WALK CYCLE',
            subtitle: 'Di chuyển từng bước dậm chân rung chuyển mặt đất',
            icon: 'footprints',
          },
      stats: { hp: 100, atk: 98, def: 92, spd: 40 },
    };
  }

  // Crosshair animation for Archer
  const aimPulse = Math.sin(frame / 3) * 0.15 + 1.0;
  const aimRotate = (frame * 3) % 360;

  // Fade flash on outfit change
  const isOutfitSwitchFrame =
    (frame >= 118 && frame <= 126) ||
    (frame >= 358 && frame <= 366) ||
    (frame >= 658 && frame <= 666) ||
    (frame >= 958 && frame <= 966);

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#000000',
        fontFamily: 'system-ui, -apple-system, sans-serif',
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

      {/* 2. Cinematic Vignette & Ambient Gradient */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `
            radial-gradient(circle at 50% 50%, transparent 55%, rgba(6, 8, 14, 0.45) 85%, rgba(6, 8, 14, 0.85) 100%),
            linear-gradient(to bottom, rgba(6, 8, 14, 0.75) 0%, transparent 18%, transparent 80%, rgba(6, 8, 14, 0.85) 100%)
          `,
          pointerEvents: 'none',
        }}
      />

      {/* Outfit Switch Flash Effect */}
      {isOutfitSwitchFrame && (
        <div
          style={{
            position: 'absolute',
            inset: 0,
            backgroundColor: scene.accentColor,
            opacity: 0.25,
            pointerEvents: 'none',
          }}
        />
      )}

      {/* ARCHER AIMING TARGET RETICLE (Shows when Archer is drawing bow!) */}
      {isArcherAiming && (
        <div
          style={{
            position: 'absolute',
            top: '45%',
            left: '50%',
            translate: '-50% -50%',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: '8px',
            pointerEvents: 'none',
          }}
        >
          <div
            style={{
              width: '120px',
              height: '120px',
              borderRadius: '50%',
              border: `2px dashed ${scene.themeColor}`,
              rotate: `${aimRotate}deg`,
              scale: `${aimPulse}`,
              boxShadow: `0 0 25px ${scene.themeColor}88`,
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            <div
              style={{
                width: '12px',
                height: '12px',
                borderRadius: '50%',
                backgroundColor: '#ef4444',
                boxShadow: '0 0 15px #ef4444',
              }}
            />
          </div>
          <div
            style={{
              backgroundColor: 'rgba(10, 15, 25, 0.8)',
              padding: '4px 12px',
              borderRadius: '6px',
              border: `1px solid ${scene.themeColor}`,
              color: '#ffffff',
              fontSize: '13px',
              fontWeight: 800,
              letterSpacing: '2px',
              textTransform: 'uppercase',
            }}
          >
            🎯 TARGET LOCKED
          </div>
        </div>
      )}

      {/* 3. TOP BAR: Cinematic Header & Monster Identification */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          height: '80px',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          padding: '0 50px',
          background:
            'linear-gradient(to bottom, rgba(8, 10, 18, 0.95) 0%, rgba(8, 10, 18, 0.7) 70%, transparent 100%)',
          borderBottom: '1px solid rgba(255, 255, 255, 0.08)',
        }}
      >
        {/* Left: Monster Title */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <div
            style={{
              width: '14px',
              height: '14px',
              borderRadius: '3px',
              backgroundColor: scene.themeColor,
              boxShadow: `0 0 12px ${scene.themeColor}`,
              rotate: '45deg',
            }}
          />
          <div>
            <div
              style={{
                fontSize: '32px',
                fontWeight: 900,
                letterSpacing: '3px',
                color: '#ffffff',
                textTransform: 'uppercase',
                textShadow: `0 0 25px ${scene.themeColor}88`,
                lineHeight: 1,
              }}
            >
              {scene.name}
            </div>
            <div
              style={{
                fontSize: '13px',
                fontWeight: 700,
                letterSpacing: '2px',
                color: scene.themeColor,
                textTransform: 'uppercase',
                marginTop: '4px',
              }}
            >
              {scene.subname}
            </div>
          </div>
        </div>

        {/* Right: Engine & Voxel Specs */}
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            backgroundColor: 'rgba(255, 255, 255, 0.05)',
            border: '1px solid rgba(255, 255, 255, 0.1)',
            padding: '8px 18px',
            borderRadius: '999px',
            fontSize: '13px',
            fontWeight: 700,
            letterSpacing: '1px',
            color: '#e2e8f0',
          }}
        >
          <span style={{ color: '#fbbf24' }}>✦</span>
          <span>GODOT ENGINE 4.7 • PROCEDURAL VOXEL RIGS</span>
        </div>
      </div>

      {/* 4. TOP-RIGHT FLOATING CARD: Dynamic Wardrobe / Outfit Badge */}
      <div
        style={{
          position: 'absolute',
          top: '95px',
          right: '50px',
          width: '380px',
          backgroundColor: 'rgba(10, 14, 24, 0.82)',
          backdropFilter: 'blur(16px)',
          border: `1px solid ${
            scene.outfit.isUpgraded ? scene.themeColor : 'rgba(255, 255, 255, 0.15)'
          }`,
          borderRadius: '14px',
          padding: '16px 20px',
          boxShadow: `0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px ${
            scene.outfit.isUpgraded ? scene.themeColor + '33' : 'transparent'
          }`,
          display: 'flex',
          flexDirection: 'column',
          gap: '6px',
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div
            style={{
              fontSize: '11px',
              fontWeight: 800,
              letterSpacing: '2px',
              color: scene.outfit.isUpgraded ? scene.accentColor : '#94a3b8',
              textTransform: 'uppercase',
              display: 'flex',
              alignItems: 'center',
              gap: '6px',
            }}
          >
            <Shirt size={14} />
            {scene.outfit.badge}
          </div>
          {scene.outfit.isUpgraded && (
            <div
              style={{
                backgroundColor: `${scene.themeColor}33`,
                border: `1px solid ${scene.themeColor}`,
                color: '#ffffff',
                padding: '2px 8px',
                borderRadius: '4px',
                fontSize: '10px',
                fontWeight: 800,
                letterSpacing: '1px',
              }}
            >
              ACTIVE OUTFIT
            </div>
          )}
        </div>

        <div
          style={{
            fontSize: '18px',
            fontWeight: 800,
            color: '#ffffff',
            letterSpacing: '0.5px',
          }}
        >
          {scene.outfit.name}
        </div>

        <div
          style={{
            fontSize: '13px',
            color: '#cbd5e1',
            lineHeight: 1.35,
          }}
        >
          {scene.outfit.desc}
        </div>
      </div>

      {/* 5. BOTTOM-LEFT FLOATING CARD: Live Animation / Action Spotlight */}
      <div
        style={{
          position: 'absolute',
          bottom: '40px',
          left: '50px',
          width: '520px',
          backgroundColor: 'rgba(10, 14, 24, 0.88)',
          backdropFilter: 'blur(16px)',
          border: `1px solid ${scene.themeColor}88`,
          borderRadius: '16px',
          padding: '20px 24px',
          boxShadow: `0 15px 40px rgba(0, 0, 0, 0.6), 0 0 25px ${scene.themeColor}33`,
          display: 'flex',
          alignItems: 'center',
          gap: '20px',
        }}
      >
        {/* Action Icon Box */}
        <div
          style={{
            width: '54px',
            height: '54px',
            borderRadius: '12px',
            backgroundColor: `${scene.themeColor}25`,
            border: `1px solid ${scene.themeColor}`,
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            color: scene.accentColor,
            flexShrink: 0,
            boxShadow: `0 0 15px ${scene.themeColor}44`,
          }}
        >
          {scene.action.icon === 'shield' && <Shield size={26} />}
          {scene.action.icon === 'footprints' && <Footprints size={26} />}
          {scene.action.icon === 'swords' && <Swords size={26} />}
          {scene.action.icon === 'crosshair' && <Crosshair size={26} />}
          {scene.action.icon === 'zap' && <Zap size={26} />}
          {scene.action.icon === 'sparkles' && <Sparkles size={26} />}
          {scene.action.icon === 'flame' && <Flame size={26} />}
          {scene.action.icon === 'shirt' && <Shirt size={26} />}
        </div>

        {/* Action Details */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '3px' }}>
          <div
            style={{
              fontSize: '11px',
              fontWeight: 800,
              letterSpacing: '2px',
              color: scene.accentColor,
              textTransform: 'uppercase',
            }}
          >
            ACTIVE ANIMATION & POSE
          </div>
          <div
            style={{
              fontSize: '22px',
              fontWeight: 900,
              color: '#ffffff',
              letterSpacing: '1px',
            }}
          >
            {scene.action.title}
          </div>
          <div
            style={{
              fontSize: '13px',
              fontWeight: 500,
              color: '#94a3b8',
              lineHeight: 1.3,
            }}
          >
            {scene.action.subtitle}
          </div>
        </div>
      </div>

      {/* 6. BOTTOM-RIGHT FLOATING CARD: RPG Combat Attributes */}
      <div
        style={{
          position: 'absolute',
          bottom: '40px',
          right: '50px',
          width: '380px',
          backgroundColor: 'rgba(10, 14, 24, 0.88)',
          backdropFilter: 'blur(16px)',
          border: '1px solid rgba(255, 255, 255, 0.12)',
          borderRadius: '16px',
          padding: '18px 24px',
          boxShadow: '0 15px 40px rgba(0, 0, 0, 0.6)',
          display: 'flex',
          flexDirection: 'column',
          gap: '10px',
        }}
      >
        <div
          style={{
            fontSize: '11px',
            fontWeight: 800,
            letterSpacing: '2px',
            color: '#94a3b8',
            textTransform: 'uppercase',
            marginBottom: '2px',
          }}
        >
          COMBAT ATTRIBUTES & SPECS
        </div>

        {[
          { label: 'HP', value: scene.stats.hp, color: '#ef4444' },
          { label: 'ATK', value: scene.stats.atk, color: '#f97316' },
          { label: 'DEF', value: scene.stats.def, color: '#3b82f6' },
          { label: 'SPD', value: scene.stats.spd, color: '#10b981' },
        ].map((stat) => (
          <div
            key={stat.label}
            style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}
          >
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                fontSize: '13px',
                fontWeight: 700,
                color: '#e2e8f0',
              }}
            >
              <span>{stat.label}</span>
              <span style={{ fontFamily: 'monospace', fontWeight: 800 }}>{stat.value}</span>
            </div>
            <div
              style={{
                width: '100%',
                height: '6px',
                backgroundColor: 'rgba(255, 255, 255, 0.08)',
                borderRadius: '3px',
                overflow: 'hidden',
              }}
            >
              <div
                style={{
                  width: `${stat.value}%`,
                  height: '100%',
                  backgroundColor: stat.color,
                  boxShadow: `0 0 8px ${stat.color}`,
                  borderRadius: '3px',
                }}
              />
            </div>
          </div>
        ))}
      </div>

      {/* Decorative Golden Corner Accents */}
      <div
        style={{
          position: 'absolute',
          top: '20px',
          left: '20px',
          width: '30px',
          height: '30px',
          borderTop: `2px solid ${scene.themeColor}`,
          borderLeft: `2px solid ${scene.themeColor}`,
          opacity: 0.7,
        }}
      />
      <div
        style={{
          position: 'absolute',
          top: '20px',
          right: '20px',
          width: '30px',
          height: '30px',
          borderTop: `2px solid ${scene.themeColor}`,
          borderRight: `2px solid ${scene.themeColor}`,
          opacity: 0.7,
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: '20px',
          left: '20px',
          width: '30px',
          height: '30px',
          borderBottom: `2px solid ${scene.themeColor}`,
          borderLeft: `2px solid ${scene.themeColor}`,
          opacity: 0.7,
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: '20px',
          right: '20px',
          width: '30px',
          height: '30px',
          borderBottom: `2px solid ${scene.themeColor}`,
          borderRight: `2px solid ${scene.themeColor}`,
          opacity: 0.7,
        }}
      />
    </AbsoluteFill>
  );
};
