-- Create products table
CREATE TABLE IF NOT EXISTS public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  category TEXT NOT NULL,
  inventory INTEGER NOT NULL DEFAULT 0,
  image_url TEXT,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Public read access (anyone can view products)
CREATE POLICY "Products are viewable by everyone"
  ON public.products
  FOR SELECT
  USING (true);

-- Create index for slug lookups
CREATE INDEX IF NOT EXISTS idx_products_slug ON public.products(slug);

-- Create index for category filtering
CREATE INDEX IF NOT EXISTS idx_products_category ON public.products(category);

-- Insert sample products
INSERT INTO public.products (name, slug, description, price, category, inventory, image_url) VALUES
('Wireless Headphones', 'wireless-headphones', 'Premium noise-canceling wireless headphones with 30-hour battery life.', 199.99, 'Electronics', 45, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'),
('Smart Watch', 'smart-watch', 'Fitness tracking smartwatch with heart rate monitor and GPS.', 299.99, 'Electronics', 28, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30'),
('Running Shoes', 'running-shoes', 'Lightweight running shoes with advanced cushioning technology.', 129.99, 'Sports', 67, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'),
('Laptop Backpack', 'laptop-backpack', 'Water-resistant backpack with multiple compartments for laptops and accessories.', 79.99, 'Accessories', 34, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62'),
('Coffee Maker', 'coffee-maker', 'Programmable coffee maker with thermal carafe and auto-shutoff.', 89.99, 'Home', 12, 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6'),
('Yoga Mat', 'yoga-mat', 'Extra thick yoga mat with non-slip surface and carrying strap.', 39.99, 'Sports', 89, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f'),
('Desk Lamp', 'desk-lamp', 'LED desk lamp with adjustable brightness and USB charging port.', 49.99, 'Home', 23, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c'),
('Bluetooth Speaker', 'bluetooth-speaker', 'Portable Bluetooth speaker with 360-degree sound and waterproof design.', 79.99, 'Electronics', 56, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1');

-- Trigger to update last_updated timestamp
CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER AS $$
BEGIN
  NEW.last_updated = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER products_last_updated
  BEFORE UPDATE ON public.products
  FOR EACH ROW
  EXECUTE FUNCTION update_last_updated();