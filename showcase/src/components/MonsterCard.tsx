import React from 'react';
import { AbsoluteFill, interpolate, useCurrentFrame, staticFile, Img, Easing } from 'remotion';
import { MonsterData } from '../types';
import { StatsBar } from './StatsBar';

interface MonsterCardProps {
  monster: MonsterData;
  durationInFrames: number;
}

export const MonsterCard: React.FC<MonsterCardProps> = ({ monster, durationInFrames }) => {
  const frame = useCurrentFrame();

  // Entrances
  const entranceOpacity = interpolate(frame, [0, 15], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const leftTranslateX = interpolate(frame, [0, 20], [-40, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const rightTranslateX = interpolate(frame, [5, 25], [50, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  // Exit transition
  const exitOpacity = interpolate(frame, [durationInFrames - 15, durationInFrames], [1, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Action pose switch occurs around frame 80
  const actionSwitchFrame = 80;
  const isActionPose = frame >= actionSwitchFrame;

  // Flash highlight on stance switch
  const flashOpacity = interpolate(
    frame,
    [actionSwitchFrame - 3, actionSwitchFrame, actionSwitchFrame + 6],
    [0, 0.4, 0],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // Floating breathing motion
  const floatY = Math.sin(frame / 15) * 6;

  // Zoom scale slowly across the scene
  const heroScale = interpolate(frame, [0, durationInFrames], [1.02, 1.08], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#0c0f17',
        backgroundImage: `
          radial-gradient(circle at 35% 50%, ${monster.bgGlow} 0%, transparent 60%),
          radial-gradient(circle at 85% 20%, rgba(255, 255, 255, 0.03) 0%, transparent 40%),
          linear-gradient(rgba(255, 255, 255, 0.02) 1px, transparent 1px),
          linear-gradient(90deg, rgba(255, 255, 255, 0.02) 1px, transparent 1px)
        `,
        backgroundSize: '100% 100%, 100% 100%, 40px 40px, 40px 40px',
        display: 'flex',
        flexDirection: 'row',
        padding: '50px 70px',
        gap: '50px',
        opacity: entranceOpacity * exitOpacity,
        fontFamily: 'system-ui, -apple-system, sans-serif',
        color: '#ffffff',
        overflow: 'hidden',
      }}
    >
      {/* LEFT COLUMN: 3D Render Showcase Viewport */}
      <div
        style={{
          flex: '1 1 56%',
          display: 'flex',
          flexDirection: 'column',
          position: 'relative',
          translate: `${leftTranslateX}px 0px`,
        }}
      >
        {/* Frame container */}
        <div
          style={{
            position: 'relative',
            width: '100%',
            height: '100%',
            borderRadius: '20px',
            overflow: 'hidden',
            border: `2px solid ${monster.primaryColor}55`,
            boxShadow: `0 20px 50px rgba(0, 0, 0, 0.7), 0 0 35px ${monster.primaryColor}33`,
            backgroundColor: '#000000',
          }}
        >
          {/* Monster Image (Idle or Action) */}
          <div
            style={{
              position: 'absolute',
              inset: 0,
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              scale: heroScale,
              translate: `0px ${floatY}px`,
            }}
          >
            <Img
              src={staticFile(isActionPose ? monster.actionImage : monster.idleImage)}
              style={{
                width: '100%',
                height: '100%',
                objectFit: 'cover',
              }}
            />
          </div>

          {/* Vignette Shadow Overlay */}
          <div
            style={{
              position: 'absolute',
              inset: 0,
              background: `
                radial-gradient(circle at 50% 50%, transparent 45%, rgba(10, 13, 20, 0.6) 80%, rgba(10, 13, 20, 0.95) 100%),
                linear-gradient(to top, rgba(10, 13, 20, 0.85) 0%, transparent 30%),
                linear-gradient(to right, rgba(10, 13, 20, 0.5) 0%, transparent 20%)
              `,
              pointerEvents: 'none',
            }}
          />

          {/* Flash overlay on stance switch */}
          {flashOpacity > 0 && (
            <div
              style={{
                position: 'absolute',
                inset: 0,
                backgroundColor: monster.accentColor,
                opacity: flashOpacity,
                pointerEvents: 'none',
              }}
            />
          )}

          {/* Top-Left Viewport Mode Badge */}
          <div
            style={{
              position: 'absolute',
              top: '20px',
              left: '20px',
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '8px 16px',
              borderRadius: '6px',
              backgroundColor: 'rgba(10, 13, 20, 0.75)',
              backdropFilter: 'blur(8px)',
              border: `1px solid ${monster.primaryColor}88`,
              fontSize: '13px',
              fontWeight: 800,
              letterSpacing: '2px',
              color: '#ffffff',
            }}
          >
            <span
              style={{
                width: '10px',
                height: '10px',
                borderRadius: '50%',
                backgroundColor: isActionPose ? '#ef4444' : '#22c55e',
                boxShadow: isActionPose ? '0 0 10px #ef4444' : '0 0 10px #22c55e',
              }}
            />
            {isActionPose ? 'STANCE: SPECIAL ACTION' : 'STANCE: IDLE COMBAT'}
          </div>

          {/* Bottom Action Skill Callout Banner */}
          <div
            style={{
              position: 'absolute',
              bottom: '24px',
              left: '24px',
              right: '24px',
              padding: '16px 20px',
              borderRadius: '12px',
              backgroundColor: 'rgba(15, 20, 32, 0.85)',
              backdropFilter: 'blur(12px)',
              border: `1px solid ${monster.primaryColor}66`,
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              boxShadow: '0 8px 30px rgba(0,0,0,0.5)',
            }}
          >
            <div>
              <div
                style={{
                  fontSize: '12px',
                  fontWeight: 800,
                  letterSpacing: '2px',
                  color: monster.accentColor,
                  textTransform: 'uppercase',
                  marginBottom: '2px',
                }}
              >
                SIGNATURE TECHNIQUE
              </div>
              <div
                style={{
                  fontSize: '22px',
                  fontWeight: 900,
                  letterSpacing: '1px',
                  color: '#ffffff',
                }}
              >
                {monster.actionName}
              </div>
            </div>

            <div
              style={{
                padding: '6px 14px',
                borderRadius: '6px',
                backgroundColor: `${monster.primaryColor}33`,
                border: `1px solid ${monster.primaryColor}`,
                fontSize: '13px',
                fontWeight: 800,
                color: monster.accentColor,
                letterSpacing: '1px',
              }}
            >
              {monster.actionType}
            </div>
          </div>
        </div>
      </div>

      {/* RIGHT COLUMN: RPG HUD Details & Stat Terminal */}
      <div
        style={{
          flex: '1 1 44%',
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'space-between',
          translate: `${rightTranslateX}px 0px`,
          padding: '10px 0',
        }}
      >
        {/* Header section */}
        <div>
          {/* Tier & Difficulty Rating */}
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '10px',
            }}
          >
            <div
              style={{
                padding: '6px 16px',
                borderRadius: '6px',
                backgroundColor: `${monster.primaryColor}25`,
                border: `1px solid ${monster.primaryColor}88`,
                fontSize: '14px',
                fontWeight: 800,
                letterSpacing: '2px',
                color: monster.accentColor,
                textTransform: 'uppercase',
              }}
            >
              {monster.tier}
            </div>

            <div
              style={{
                display: 'flex',
                gap: '4px',
                fontSize: '20px',
                color: '#fbbf24',
                textShadow: '0 0 10px rgba(251, 191, 36, 0.6)',
              }}
            >
              {'★'.repeat(monster.difficulty)}
              {'☆'.repeat(5 - monster.difficulty)}
            </div>
          </div>

          {/* Name & Title */}
          <div
            style={{
              fontSize: '56px',
              fontWeight: 900,
              letterSpacing: '2px',
              lineHeight: 1.05,
              textTransform: 'uppercase',
              background: `linear-gradient(180deg, #ffffff 40%, ${monster.accentColor} 100%)`,
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              textShadow: `0 0 30px ${monster.primaryColor}66`,
              marginBottom: '6px',
            }}
          >
            {monster.name}
          </div>

          {/* Subtitle / Role */}
          <div
            style={{
              fontSize: '20px',
              fontWeight: 700,
              letterSpacing: '3px',
              color: monster.primaryColor,
              textTransform: 'uppercase',
              marginBottom: '16px',
            }}
          >
            {monster.title} • {monster.role}
          </div>

          {/* Luminous separator bar */}
          <div
            style={{
              width: '100%',
              height: '3px',
              background: `linear-gradient(90deg, ${monster.primaryColor} 0%, ${monster.accentColor} 50%, transparent 100%)`,
              borderRadius: '2px',
              boxShadow: `0 0 10px ${monster.primaryColor}`,
              marginBottom: '20px',
            }}
          />

          {/* Monster Quote */}
          <div
            style={{
              padding: '14px 18px',
              borderRadius: '8px',
              backgroundColor: 'rgba(255, 255, 255, 0.04)',
              borderLeft: `4px solid ${monster.primaryColor}`,
              fontSize: '16px',
              fontStyle: 'italic',
              color: '#cbd5e1',
              lineHeight: 1.4,
              marginBottom: '20px',
            }}
          >
            {monster.quote}
          </div>

          {/* Weapon & Outfits Chips */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', marginBottom: '24px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <span style={{ fontSize: '13px', fontWeight: 800, color: '#94a3b8', letterSpacing: '1px' }}>
                PRIMARY WEAPON:
              </span>
              <span
                style={{
                  fontSize: '14px',
                  fontWeight: 700,
                  color: '#f8fafc',
                  backgroundColor: 'rgba(255,255,255,0.08)',
                  padding: '4px 10px',
                  borderRadius: '4px',
                }}
              >
                ⚔️ {monster.weapon}
              </span>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap' }}>
              <span style={{ fontSize: '13px', fontWeight: 800, color: '#94a3b8', letterSpacing: '1px' }}>
                VOXEL WARDROBE:
              </span>
              {monster.outfits.map((outfit, idx) => (
                <span
                  key={idx}
                  style={{
                    fontSize: '13px',
                    fontWeight: 600,
                    color: '#e2e8f0',
                    backgroundColor: 'rgba(255,255,255,0.06)',
                    border: '1px solid rgba(255,255,255,0.1)',
                    padding: '3px 8px',
                    borderRadius: '4px',
                  }}
                >
                  {outfit}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* Dynamic Combat Stats Section */}
        <div
          style={{
            padding: '20px 24px',
            borderRadius: '14px',
            backgroundColor: 'rgba(15, 20, 32, 0.7)',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            display: 'flex',
            flexDirection: 'column',
            gap: '14px',
            boxShadow: 'inset 0 0 20px rgba(0,0,0,0.5)',
          }}
        >
          <div
            style={{
              fontSize: '14px',
              fontWeight: 800,
              letterSpacing: '2px',
              color: '#94a3b8',
              textTransform: 'uppercase',
              marginBottom: '2px',
            }}
          >
            COMBAT SPECIFICATIONS & ATTRIBUTES
          </div>

          <StatsBar label="Health (HP)" value={monster.stats.hp} color="#ef4444" delayFrames={10} />
          <StatsBar label="Attack (ATK)" value={monster.stats.atk} color="#f97316" delayFrames={15} />
          <StatsBar label="Defense (DEF)" value={monster.stats.def} color="#3b82f6" delayFrames={20} />
          <StatsBar label="Agility (SPD)" value={monster.stats.spd} color="#10b981" delayFrames={25} />
        </div>
      </div>
    </AbsoluteFill>
  );
};
