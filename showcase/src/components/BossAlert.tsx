import React from 'react';
import { AbsoluteFill, interpolate, useCurrentFrame } from 'remotion';

export const BossAlert: React.FC = () => {
  const frame = useCurrentFrame();

  // Flashing red emergency pulse
  const strobe = Math.sin(frame * 0.5) > 0 ? 0.35 : 0.1;
  const shakeX = (frame % 4 < 2 ? 1 : -1) * (3 + Math.sin(frame * 0.8) * 3);
  const shakeY = (frame % 6 < 3 ? -1 : 1) * 2;

  const textScale = interpolate(frame, [0, 15], [0.8, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const hazardOffset = (frame * 12) % 60;

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#0f0505',
        backgroundImage: `radial-gradient(circle at 50% 50%, rgba(239, 68, 68, ${strobe}) 0%, transparent 75%)`,
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        fontFamily: 'system-ui, -apple-system, sans-serif',
        color: '#ffffff',
        overflow: 'hidden',
        translate: `${shakeX}px ${shakeY}px`,
      }}
    >
      {/* Top Hazard Caution Banner */}
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: -100,
          right: -100,
          height: '40px',
          background: `repeating-linear-gradient(
            -45deg,
            #ef4444,
            #ef4444 25px,
            #000000 25px,
            #000000 50px
          )`,
          translate: `${hazardOffset}px 0px`,
          borderBottom: '3px solid #ff0000',
        }}
      />

      {/* Bottom Hazard Caution Banner */}
      <div
        style={{
          position: 'absolute',
          bottom: 0,
          left: -100,
          right: -100,
          height: '40px',
          background: `repeating-linear-gradient(
            -45deg,
            #ef4444,
            #ef4444 25px,
            #000000 25px,
            #000000 50px
          )`,
          translate: `${-hazardOffset}px 0px`,
          borderTop: '3px solid #ff0000',
        }}
      />

      {/* Alert Warning Box */}
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          scale: textScale,
        }}
      >
        <div
          style={{
            padding: '8px 28px',
            borderRadius: '999px',
            backgroundColor: '#dc2626',
            color: '#ffffff',
            fontSize: '22px',
            fontWeight: 900,
            letterSpacing: '5px',
            textTransform: 'uppercase',
            boxShadow: '0 0 35px #dc2626',
            marginBottom: '20px',
          }}
        >
          🚨 PRIORITY CLASS S ALERT 🚨
        </div>

        <div
          style={{
            fontSize: '96px',
            fontWeight: 900,
            letterSpacing: '8px',
            color: '#ffffff',
            textShadow: '0 0 50px #ef4444, 0 0 100px #dc2626',
            textTransform: 'uppercase',
            textAlign: 'center',
            lineHeight: 1,
            marginBottom: '16px',
          }}
        >
          ANCIENT COLOSSUS
          <br />
          APPROACHING
        </div>

        <div
          style={{
            fontSize: '28px',
            fontWeight: 700,
            letterSpacing: '4px',
            color: '#fca5a5',
            textTransform: 'uppercase',
            textAlign: 'center',
            maxWidth: '900px',
          }}
        >
          SEISMIC SHOCKWAVES REGISTERED • TARGET: MACE OGRE
        </div>
      </div>
    </AbsoluteFill>
  );
};
