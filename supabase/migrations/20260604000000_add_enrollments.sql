-- ============================================================
-- Migration: Add Enrollments, Certificates, Favorite Courses
-- Created: 2026-06-04
-- ============================================================

-- ─────────────────────────────────────────────
-- 1. ENROLLMENTS TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS enrollments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  payment_status   TEXT NOT NULL DEFAULT 'completed',  -- pending | completed | refunded
  enrolled_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_accessed_at TIMESTAMP WITH TIME ZONE,
  created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_enrollments_user    ON enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course  ON enrollments(course_id);

ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- Users can view their own enrollments
CREATE POLICY "Users can view their own enrollments" ON enrollments
  FOR SELECT USING (auth.uid()::text = user_id::text);

-- Users can insert their own enrollments
CREATE POLICY "Users can create their own enrollments" ON enrollments
  FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Users can update their own enrollments (e.g. last_accessed_at)
CREATE POLICY "Users can update their own enrollments" ON enrollments
  FOR UPDATE USING (auth.uid()::text = user_id::text);

-- ─────────────────────────────────────────────
-- 2. CERTIFICATES TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS certificates (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id       UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  issued_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  certificate_url TEXT,
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_certificates_user ON certificates(user_id);

ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own certificates" ON certificates
  FOR SELECT USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can create their own certificates" ON certificates
  FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- ─────────────────────────────────────────────
-- 3. FAVORITE COURSES TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS favorite_courses (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id  UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorite_courses(user_id);

ALTER TABLE favorite_courses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own favorites" ON favorite_courses
  FOR SELECT USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can manage their own favorites" ON favorite_courses
  FOR ALL USING (auth.uid()::text = user_id::text);

-- ─────────────────────────────────────────────
-- 4. SEED: Enroll the mock student into courses
--    that already have course_progress rows
-- ─────────────────────────────────────────────
INSERT INTO enrollments (user_id, course_id, payment_status, enrolled_at)
VALUES
  ('9999ee9d-ff46-4cb4-972c-f68482bf4f17', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', 'completed', NOW() - INTERVAL '10 days'),
  ('9999ee9d-ff46-4cb4-972c-f68482bf4f17', '2232ff3f-ab57-4cc5-a63d-a79493cf5a33', 'completed', NOW() - INTERVAL '5 days')
ON CONFLICT (user_id, course_id) DO NOTHING;
