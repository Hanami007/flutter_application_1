-- LearnHub Database Seed Data Script
-- Paste this script into the Supabase SQL Editor to populate mock data.

-- 1. Insert Seed Users (Instructors and Students)
INSERT INTO users (id, email, full_name, phone_number, address, profile_image_url, auth_id)
VALUES 
  ('1219ee9d-ff46-4cb4-972c-f68482bf4f17', 'john.smith@learnhub.com', 'John Smith', '081-234-5678', 'Pathum Wan, Bangkok', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop', NULL),
  ('a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad', 'jane.doe@learnhub.com', 'Jane Doe', '082-345-6789', 'Asoke, Bangkok', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop', NULL),
  ('c6a0c5c4-42b7-4aef-b20b-193de3f13c6b', 'mike.johnson@learnhub.com', 'Mike Johnson', '083-456-7890', 'Ladprao, Bangkok', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop', NULL),
  ('4a9fa3bc-452f-410a-8bf7-e54e4e9bc35a', 'emily.brown@learnhub.com', 'Emily Brown', '084-567-8901', 'Sathorn, Bangkok', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop', NULL),
  ('9999ee9d-ff46-4cb4-972c-f68482bf4f17', 'student@learnhub.com', 'Guest User', '089-999-9999', 'Bangkok', NULL, NULL)
ON CONFLICT (email) DO NOTHING;

-- 2. Insert Seed Teachers (linking to Users)
INSERT INTO teachers (id, user_id, bio, qualifications, experience_years, rating)
VALUES
  ('7df20330-8a22-4467-bc85-98317c24a275', '1219ee9d-ff46-4cb4-972c-f68482bf4f17', 'Expert Flutter and Mobile Developer with 8+ years of industry experience.', 'M.Sc. in Computer Science', 8, 4.9),
  ('86cb6c32-2d85-48b5-9017-f3162235c024', 'a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad', 'Senior UI/UX Designer specialized in creating accessible and premium modern digital products.', 'B.FA. in Graphic Design', 6, 4.8),
  ('f7808269-8a35-4cb2-a727-4632b7a972f0', 'c6a0c5c4-42b7-4aef-b20b-193de3f13c6b', 'Data Scientist and AI researcher with a passion for teaching complex concepts simply.', 'Ph.D. in Data Analytics', 10, 4.7),
  ('34f0c4bb-d9b8-4c8d-8a4e-bf2cf2825c34', '4a9fa3bc-452f-410a-8bf7-e54e4e9bc35a', 'Digital marketer and strategist who has scaled multiple startups from 0 to millions in revenue.', 'MBA in Marketing', 5, 4.6)
ON CONFLICT (user_id) DO NOTHING;

-- 3. Insert Seed Categories
INSERT INTO categories (id, name, description, icon_url)
VALUES
  ('8f3b2072-881c-4b62-b2d9-1ff04c15144b', 'Development', 'Web development, mobile apps, and programming languages', 'developer_mode'),
  ('035f5240-7cc5-4eb8-bb2f-6571fa79bf77', 'Design', 'UI/UX design, graphic design, and video editing', 'palette'),
  ('6db8efcc-a477-4c4f-a496-93cb7ce5768e', 'Data Science', 'Machine learning, data analytics, and AI models', 'analytics'),
  ('c36d2e67-d874-4b53-b09e-711e5491f24d', 'Business', 'Marketing, startups, leadership, and finance', 'business_center'),
  ('68a2ee3e-67fe-4ec6-89bf-1e64906f23ee', 'Languages', 'English, Japanese, Chinese, and communication skills', 'language')
ON CONFLICT (name) DO NOTHING;

-- 4. Insert Seed Courses
INSERT INTO courses (id, name, description, category_id, instructor_id, thumbnail_url, price, duration, level, rating, total_students)
VALUES
  ('1121ee2e-fa46-4bb4-952c-f68482bf4f22', 'Flutter Mobile Development (Masterclass)', 'เรียนรู้การพัฒนา Mobile Application ด้วย Flutter และ Dart ตั้งแต่พื้นฐานจนถึงการเชื่อมต่อฐานข้อมูลจริง สร้างแอปพลิเคชันที่สวยงาม รวดเร็ว และรองรับทั้ง iOS และ Android อย่างมืออาชีพ', '8f3b2072-881c-4b62-b2d9-1ff04c15144b', '1219ee9d-ff46-4cb4-972c-f68482bf4f17', 'https://images.unsplash.com/photo-1617042375876-a13e36732a04?q=80&w=600&auto=format&fit=crop', 3500.00, 40, 'Beginner', 4.8, 1540),
  ('2232ff3f-ab57-4cc5-a63d-a79493cf5a33', 'UI/UX Design Essentials with Figma', 'ออกแบบแอปพลิเคชันและเว็บไซต์ให้ตอบโจทย์ผู้ใช้งานและดูทันสมัย เรียนรู้หลักการจัดวางสี Typography การทำ Wireframe และ High-fidelity Prototype ด้วย Figma พร้อมเทคนิคการทำงานร่วมกับนักพัฒนา', '035f5240-7cc5-4eb8-bb2f-6571fa79bf77', 'a5b7c729-ea21-4f1a-b6d1-92b1cb5705ad', 'https://images.unsplash.com/photo-1561070791-26c113006238?q=80&w=600&auto=format&fit=crop', 2900.00, 24, 'Intermediate', 4.7, 890),
  ('3343aa4a-bc68-4dd6-b74e-b8a594df6b44', 'Advanced Dart & Clean Architecture', 'เจาะลึกภาษา Dart ขั้นสูง โครงสร้างแบบ Clean Architecture การจัดการ State ด้วย Riverpod และการเขียน Unit/Widget/Integration Tests สำหรับโปรเจกต์ระดับโปรดักชันที่มีเสถียรภาพสูง', '8f3b2072-881c-4b62-b2d9-1ff04c15144b', '1219ee9d-ff46-4cb4-972c-f68482bf4f17', 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?q=80&w=600&auto=format&fit=crop', 4200.00, 30, 'Advanced', 4.9, 450),
  ('4454bb5b-cd79-4ee7-c85f-c9b695ef7c55', 'Data Science & ML with Python', 'วิเคราะห์ข้อมูลขนาดใหญ่และสร้างโมเดล Machine Learning ด้วยภาษา Python เรียนรู้การใช้งาน Pandas, NumPy, Scikit-Learn และการแสดงผลข้อมูลด้วย Matplotlib และ Seaborn ครบจบในคอร์สเดียว', '6db8efcc-a477-4c4f-a496-93cb7ce5768e', 'c6a0c5c4-42b7-4aef-b20b-193de3f13c6b', 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=600&auto=format&fit=crop', 3800.00, 35, 'Beginner', 4.6, 1200),
  ('5565cc6c-de80-4ff8-d96f-d0c796f88d66', 'Digital Marketing & SEO Strategies', 'กลยุทธ์การทำตลาดออนไลน์ให้ประสบความสำเร็จและยั่งยืน เรียนรู้การทำ SEO, SEM, ยิงโฆษณา Facebook/Google Ads และการวัดผลวิเคราะห์ข้อมูลผู้เยี่ยมชมอย่างแม่นยำด้วย Google Analytics', 'c36d2e67-d874-4b53-b09e-711e5491f24d', '4a9fa3bc-452f-410a-8bf7-e54e4e9bc35a', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=600&auto=format&fit=crop', 2500.00, 20, 'Beginner', 4.5, 620);

-- 5. Insert Seed Branches
INSERT INTO branches (id, name, address, city, state, zip_code, phone, latitude, longitude, capacity)
VALUES
  ('b1122cc3-dd44-4ee5-bf66-aa77bb88cc99', 'LearnHub Siam Square', 'Floor 4, Siam Square One, Pathum Wan', 'Bangkok', 'Bangkok', '10330', '02-123-4567', 13.74440000, 100.53500000, 50),
  ('b2233dd4-ee55-4ff6-c077-bb88cc99ddaa', 'LearnHub Asoke Center', 'Floor 12, Exchange Tower, Sukhumvit Road', 'Bangkok', 'Bangkok', '10110', '02-765-4321', 13.73600000, 100.56040000, 40);

-- 6. Insert Seed Class Sessions
INSERT INTO class_sessions (id, course_id, branch_id, teacher_id, session_type, start_time, end_time, capacity, enrolled_count, status, recording_url, meeting_link)
VALUES
  ('s1122dd3-ee44-4ff5-bf66-aa77bb88cc99', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', 'b1122cc3-dd44-4ee5-bf66-aa77bb88cc99', '7df20330-8a22-4467-bc85-98317c24a275', 'onsite', NOW() + INTERVAL '1 day 2 hours', NOW() + INTERVAL '1 day 5 hours', 25, 18, 'scheduled', NULL, NULL),
  ('s2233ee4-ff55-4006-c077-bb88cc99ddaa', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', NULL, '7df20330-8a22-4467-bc85-98317c24a275', 'online', NOW() + INTERVAL '3 days 6 hours', NOW() + INTERVAL '3 days 8 hours', 100, 45, 'scheduled', NULL, 'https://zoom.us/j/1234567890'),
  ('s3344ff5-0066-4117-d188-cc99ee00ffbb', '2232ff3f-ab57-4cc5-a63d-a79493cf5a33', 'b2233dd4-ee55-4ff6-c077-bb88cc99ddaa', '86cb6c32-2d85-48b5-9017-f3162235c024', 'onsite', NOW() + INTERVAL '2 days 3 hours', NOW() + INTERVAL '2 days 6 hours', 20, 12, 'scheduled', NULL, NULL);

-- 7. Insert Seed Videos (Lessons)
INSERT INTO videos (id, course_id, title, description, video_url, thumbnail_url, duration, order_index)
VALUES
  ('v1111111-2222-3333-4444-555555555551', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', '1. Introduction to Flutter & Dart', 'ทำความรู้จักกับ Flutter framework และภาษา Dart รวมถึงข้อดีและการเขียนเบื้องต้น', 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4', 'https://images.unsplash.com/photo-1542831371-29b0f74f9713', 650, 1),
  ('v2222222-3333-4444-5555-666666666662', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', '2. Flutter Widgets Basics', 'เรียนรู้การทำงานของ Stateless และ Stateful Widget และการจัด Layout ด้วย Row/Column', 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4', 'https://images.unsplash.com/photo-1617042375876-a13e36732a04', 920, 2),
  ('v3333333-4444-5555-6666-777777777773', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', '3. Navigation and Routing', 'การสลับหน้าจอใน Flutter โดยใช้ Navigator และการส่งค่าข้ามหน้า', 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97', 800, 3),
  ('v4444444-5555-6666-7777-888888888884', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', '4. State Management with Riverpod', 'เจาะลึกการใช้ Riverpod เพื่อควบคุมสถานะของแอปพลิเคชันอย่างเป็นระบบและมีประสิทธิภาพ', 'https://assets.mixkit.co/videos/preview/mixkit-software-developer-working-on-his-computer-34281-large.mp4', 'https://images.unsplash.com/photo-1605379399642-870262d3d051', 1100, 4);

-- 8. Insert Seed Course Progress (linking to default student)
INSERT INTO course_progress (id, user_id, course_id, videos_watched, videos_total, progress_percentage)
VALUES
  ('3f8b0304-4b5c-4be6-98dc-b62c1285dbaf', '9999ee9d-ff46-4cb4-972c-f68482bf4f17', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', 6, 8, 75.00),
  ('707b22ff-c774-4b52-b883-ef4aa97c6d66', '9999ee9d-ff46-4cb4-972c-f68482bf4f17', '2232ff3f-ab57-4cc5-a63d-a79493cf5a33', 3, 8, 37.50)
ON CONFLICT (user_id, course_id) DO NOTHING;

-- 9. Seed Enrollments (for the mock student who already has course_progress)
INSERT INTO enrollments (user_id, course_id, payment_status, enrolled_at)
VALUES
  ('9999ee9d-ff46-4cb4-972c-f68482bf4f17', '1121ee2e-fa46-4bb4-952c-f68482bf4f22', 'completed', NOW() - INTERVAL '10 days'),
  ('9999ee9d-ff46-4cb4-972c-f68482bf4f17', '2232ff3f-ab57-4cc5-a63d-a79493cf5a33', 'completed', NOW() - INTERVAL '5 days')
ON CONFLICT (user_id, course_id) DO NOTHING;

