import { useState } from 'react';
import { Link, useLocation } from 'wouter';
import { Button } from '@/components/ui/button';
import { 
  Home, 
  Users, 
  Calendar, 
  DollarSign, 
  ShoppingCart, 
  MessageSquare, 
  FileText,
  Menu,
  X,
  LogOut
} from 'lucide-react';
import { useUnifiedAuth } from '@/hooks/useUnifiedAuth';

interface AdminLayoutProps {
  children: React.ReactNode;
}

export default function AdminLayout({ children }: AdminLayoutProps) {
  const [location] = useLocation();
  const { user, logout, isAuthenticated } = useUnifiedAuth();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const navItems = [
    { href: '/admin', label: 'Dashboard', icon: Home },
    { href: '/admin/users', label: 'Users', icon: Users },
    { href: '/admin/classes', label: 'Classes', icon: Calendar },
    { href: '/admin/memberships', label: 'Memberships', icon: DollarSign },
    { href: '/admin/products', label: 'Products', icon: ShoppingCart },
    { href: '/admin/testimonials', label: 'Testimonials', icon: MessageSquare },
    { href: '/admin/pages', label: 'Pages', icon: FileText },
  ];

  const closeMobileMenu = () => {
    setIsMobileMenuOpen(false);
  };

  if (!isAuthenticated || user?.role !== 'admin') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-muted">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-destructive">Access Denied</h1>
          <p className="text-muted-foreground mt-2">Admin access required</p>
          <Link href="/">
            <Button className="mt-4">Go Home</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background flex">
      {/* Mobile menu button */}
      <div className="md:hidden fixed top-4 left-4 z-50">
        <Button
          variant="outline"
          size="icon"
          onClick={() => setIsMobileMenuOpen(true)}
        >
          <Menu className="h-5 w-5" />
        </Button>
      </div>

      {/* Mobile sidebar overlay */}
      {isMobileMenuOpen && (
        <div 
          className="fixed inset-0 z-40 bg-black/50 md:hidden"
          onClick={closeMobileMenu}
        />
      )}

      {/* Sidebar */}
      <aside 
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-muted border-r p-4 flex flex-col transform transition-transform duration-300 ease-in-out md:translate-x-0
          ${isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'} md:static md:translate-x-0`}
      >
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-xl font-bold">Admin Panel</h1>
          <Button
            variant="outline"
            size="icon"
            className="md:hidden"
            onClick={() => setIsMobileMenuOpen(false)}
          >
            <X className="h-5 w-5" />
          </Button>
        </div>

        <nav className="flex-1">
          <ul className="space-y-2">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = location === item.href;
              return (
                <li key={item.href}>
                  <Link href={item.href} onClick={closeMobileMenu}>
                    <Button
                      variant={isActive ? "secondary" : "ghost"}
                      className={`w-full justify-start ${isActive ? 'bg-primary text-primary-foreground' : ''}`}
                    >
                      <Icon className="h-4 w-4 mr-3" />
                      {item.label}
                    </Button>
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="mt-auto pt-8 border-t">
          <div className="text-sm text-muted-foreground mb-2">
            Signed in as {user?.email}
          </div>
          <Button
            variant="outline"
            className="w-full"
            onClick={() => {
              logout();
              window.location.href = '/';
            }}
          >
            <LogOut className="h-4 w-4 mr-2" />
            Logout
          </Button>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 md:ml-0 pt-16 md:pt-0">
        <div className="p-4 md:p-8">
          {children}
        </div>
      </main>
    </div>
  );
}