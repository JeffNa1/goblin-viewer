export interface MonsterStat {
  label: string;
  value: number; // 0 to 100
  display: string;
  color: string;
}

export interface MonsterData {
  id: string;
  name: string;
  title: string;
  role: string;
  tier: string;
  difficulty: number; // 1 to 5 stars
  primaryColor: string;
  accentColor: string;
  bgGlow: string;
  idleImage: string;
  actionImage: string;
  actionName: string;
  actionType: string;
  description: string;
  quote: string;
  weapon: string;
  outfits: string[];
  stats: {
    hp: number;
    atk: number;
    def: number;
    spd: number;
  };
}
