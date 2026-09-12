import React from 'react';
import { AbsoluteFill, interpolate, useCurrentFrame, Easing } from 'remotion';

export const IntroScene: React.FC = () => {
  const frame = useCurrentFrame();

  // Entrance animations
  const titleOpacity = interpolate(frame, [10, 35], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const titleScale = interpolate(frame, [10, 45], [0.88, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const subtitleOpacity = interpolate(frame, [30, 50], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const subtitleTranslateY = interpolate(frame, [30, 50], [20, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const badgeOpacity = interpolate(frame, [45, 65], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Exit transition
  const exitOpacity = interpolate(frame, [105, 120], [1, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const pulseGlow = interpolate(Math.sin(frame / 8), [-1, 1], [0.4, 0.8]);

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#0a0d14',
        backgroundImage: `
          radial-gradient(circle at 50% 50%, rgba(224, 122, 56, 0.15) 0%, transparent 65%),
          radial-gradient(circle at 20% 80%, rgba(159, 122, 234, 0.12) 0%, transparent 50%),
          linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px)
        `,
        backgroundSize: '100% 100%, 100% 100%, 48px 48px, 48px 48px',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        opacity: exitOpacity,
        fontFamily: 'system-ui, -apple-system, sans-serif',
        color: '#ffffff',
        overflow: 'hidden',
      }}
    >
      {/* Decorative Runic Frame Corner Accents */}
      <div
        style={{
          position: 'absolute',
          top: 40,
          left: 40,
          width: 80,
          height: 80,
          borderTop: '2px solid rgba(224, 122, 56, 0.6)',
          borderLeft: '2px solid rgba(224, 122, 56, 0.6)',
        }}
      />
      <div
        style={{
          position: 'absolute',
          top: 40,
          right: 40,
          width: 80,
          height: 80,
          borderTop: '2px solid rgba(224, 122, 56, 0.6)',
          borderRight: '2px solid rgba(224, 122, 56, 0.6)',
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: 40,
          left: 40,
          width: 80,
          height: 80,
          borderBottom: '2px solid rgba(224, 122, 56, 0.6)',
          borderLeft: '2px solid rgba(224, 122, 56, 0.6)',
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: 40,
          right: 40,
          width: 80,
          height: 80,
          borderBottom: '2px solid rgba(224, 122, 56, 0.6)',
          borderRight: '2px solid rgba(224, 122, 56, 0.6)',
        }}
      />

      {/* Category Pill Tag */}
      <div
        style={{
          opacity: subtitleOpacity,
          translate: `0px ${subtitleTranslateY}px`,
          padding: '8px 24px',
          borderRadius: '999px',
          backgroundColor: 'rgba(224, 122, 56, 0.15)',
          border: '1px solid rgba(224, 122, 56, 0.4)',
          color: '#fbbf24',
          fontSize: '18px',
          fontWeight: 800,
          letterSpacing: '4px',
          textTransform: 'uppercase',
          marginBottom: '24px',
          boxShadow: '0 0 20px rgba(224, 122, 56, 0.3)',
        }}
      >
        ✦ 3D VOXEL BESTIARY SHOWCASE ✦
      </div>

      {/* Main Title */}
      <div
        style={{
          opacity: titleOpacity,
          scale: titleScale,
          fontSize: '84px',
          fontWeight: 900,
          letterSpacing: '6px',
          textAlign: 'center',
          lineHeight: 1.1,
          textTransform: 'uppercase',
          textShadow: `0 0 40px rgba(224, 122, 56, ${pulseGlow}), 0 4px 16px rgba(0, 0, 0, 0.8)`,
          background: 'linear-gradient(180deg, #ffffff 30%, #f97316 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          marginBottom: '20px',
        }}
      >
        CHRONICLES OF THE
        <br />
        GOBLIN HORDE
      </div>

      {/* Subtitle / Engine Info */}
      <div
        style={{
          opacity: subtitleOpacity,
          translate: `0px ${subtitleTranslateY}px`,
          fontSize: '24px',
          fontWeight: 500,
          letterSpacing: '2px',
          color: '#cbd5e1',
          marginBottom: '48px',
          textAlign: 'center',
        }}
      >
        Real-Time Procedural 3D Voxel Characters & Skeletal Animations • Godot 4.x
      </div>

      {/* Feature Badges */}
      <div
        style={{
          opacity: badgeOpacity,
          display: 'flex',
          gap: '24px',
          justifyContent: 'center',
        }}
      >
        {[
          { label: '5 DISTINCT CLASSES', icon: '⚔️' },
          { label: 'HIGH-POLY PRIMITIVE VOXELS', icon: '💎' },
          { label: 'SKELETAL INVERSE KINEMATICS', icon: '🦴' },
          { label: 'COLOSSAL MACE OGRE BOSS', icon: '👹' },
        ].map((badge, idx) => (
          <div
            key={idx}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '12px 20px',
              borderRadius: '8px',
              backgroundColor: 'rgba(255, 255, 255, 0.05)',
              border: '1px solid rgba(255, 255, 255, 0.1)',
              fontSize: '15px',
              fontWeight: 700,
              letterSpacing: '1px',
              color: '#f1f5f9',
              backdropFilter: 'blur(8px)',
            }}
          >
            <span>{badge.icon}</span>
            <span>{badge.label}</span>
          </div>
        ))}
      </div>
    </AbsoluteFill>
  );
};
