-- REPORTS TABLE SETUP
-- À exécuter dans Supabase > SQL Editor

CREATE TABLE IF NOT EXISTS reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  place_id UUID REFERENCES places(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  reason TEXT NOT NULL CHECK (reason IN ('closed', 'maintenance', 'wrong_location', 'duplicate', 'wrong_info', 'inappropriate', 'other')),
  details TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'resolved', 'dismissed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Tout le monde peut lire (nécessaire pour afficher le badge ⚠️ dans le popup)
CREATE POLICY "lecture publique reports" ON reports FOR SELECT USING (true);

-- Seul l'auteur peut insérer
CREATE POLICY "insert authentifie reports" ON reports FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Suppression réservée à l'admin via le panel
CREATE POLICY "delete admin reports" ON reports FOR DELETE USING (true);
