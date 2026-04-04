-- Enable Row Level Security
-- Profiles table
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT,
    avatar_url TEXT,
    skills TEXT[], -- Array of skills
    bio TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Chats table (for both direct and group chats)
CREATE TABLE chats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT, -- Optional name for group chats
    is_group BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Chat participants junction table
CREATE TABLE chat_participants (
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (chat_id, profile_id)
);

-- Messages table
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reviews table
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reviewer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    reviewee_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hackathons table
CREATE TABLE hackathons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    location TEXT,
    date DATE,
    link TEXT,
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up Row Level Security (RLS)
-- Profiles: Everyone can read, only owner can update
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile." ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

-- Chats: Users can read chats they are participants of
ALTER TABLE chats ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own chats." ON chats FOR SELECT
USING (EXISTS (SELECT 1 FROM chat_participants WHERE chat_id = id AND profile_id = auth.uid()));
CREATE POLICY "Users can create chats." ON chats FOR INSERT WITH CHECK (true);

-- Chat Participants: Users can view and join chats
ALTER TABLE chat_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view chat participants." ON chat_participants FOR SELECT
USING (EXISTS (SELECT 1 FROM chat_participants cp WHERE cp.chat_id = chat_id AND cp.profile_id = auth.uid()));
CREATE POLICY "Users can add themselves to chats." ON chat_participants FOR INSERT WITH CHECK (auth.uid() = profile_id);

-- Messages: (Already set above, but ensuring consistency)
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read messages in their chats." ON messages FOR SELECT
USING (EXISTS (SELECT 1 FROM chat_participants WHERE chat_id = messages.chat_id AND profile_id = auth.uid()));
CREATE POLICY "Users can insert messages in their chats." ON messages FOR INSERT
WITH CHECK (auth.uid() = sender_id AND EXISTS (SELECT 1 FROM chat_participants WHERE chat_id = messages.chat_id AND profile_id = auth.uid()));

-- Hackathons: Public read, anyone can post (for now)
ALTER TABLE hackathons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public hackathons are viewable by everyone." ON hackathons FOR SELECT USING (true);
CREATE POLICY "Authenticated users can post hackathons." ON hackathons FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Reviews: Public read, owner can manage
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public reviews are viewable by everyone." ON reviews FOR SELECT USING (true);
CREATE POLICY "Authenticated users can post reviews." ON reviews FOR INSERT WITH CHECK (auth.uid() = reviewer_id);

-- Realtime settings
-- Go to Supabase Dashboard > Database > Replication > Source to enable for these tables.
