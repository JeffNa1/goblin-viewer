import React from 'react';
import { Composition } from 'remotion';
import { PolishedShowcase } from './PolishedShowcase';
import { VoxelPixelShowcase } from './VoxelPixelShowcase';

export const Root: React.FC = () => {
  return (
    <>
      <Composition
        id="VoxelPixelShowcase"
        component={VoxelPixelShowcase}
        durationInFrames={1440}
        fps={30}
        width={1920}
        height={1080}
      />
      <Composition
        id="PolishedShowcase"
        component={PolishedShowcase}
        durationInFrames={1440}
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};
