import React from 'react';
import { interpolate, useCurrentFrame, Easing } from 'remotion';

interface StatsBarProps {
  label: string;
  value: number; // 0 to 100
  color: string;
  delayFrames?: number;
}

export const StatsBar: React.FC<StatsBarProps> = ({
  label,
  value,
  color,
  delayFrames = 15,
}) => {
  const frame = useCurrentFrame();

  const progress = interpolate(frame, [delayFrames, delayFrames + 25], [0, value], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const barOpacity = interpolate(frame, [delayFrames, delayFrames + 10], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '6px',
        opacity: barOpacity,
      }}
    >
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          fontSize: '18px',
          fontWeight: 700,
          letterSpacing: '1px',
          textTransform: 'uppercase',
          color: '#e2e8f0',
          fontFamily: 'system-ui, -apple-system, sans-serif',
        }}
      >
        <span style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span
            style={{
              width: '8px',
              height: '8px',
              borderRadius: '2px',
              backgroundColor: color,
              boxShadow: `0 0 8px ${color}`,
            }}
          />
          {label}
        </span>
        <span
          style={{
            fontFamily: 'monospace',
            color: '#ffffff',
            fontWeight: 800,
            fontSize: '20px',
          }}
        >
          {Math.round(progress)}
        </span>
      </div>

      <div
        style={{
          width: '100%',
          height: '14px',
          backgroundColor: 'rgba(255, 255, 255, 0.08)',
          borderRadius: '6px',
          overflow: 'hidden',
          border: '1px solid rgba(255, 255, 255, 0.12)',
          position: 'relative',
        }}
      >
        <div
          style={{
            width: `${progress}%`,
            height: '100%',
            background: `linear-gradient(90deg, ${color}99 0%, ${color} 100%)`,
            borderRadius: '4px',
            boxShadow: `0 0 12px ${color}88`,
            position: 'relative',
          }}
        >
          <div
            style={{
              position: 'absolute',
              right: 0,
              top: 0,
              bottom: 0,
              width: '4px',
              backgroundColor: '#ffffff',
              boxShadow: '0 0 8px #ffffff',
            }}
          />
        </div>
      </div>
    </div>
  );
};
