import { useQuery } from "@tanstack/react-query";
import { useParams } from "wouter";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import Navigation from "@/components/navigation";
import Footer from "@/components/footer";
import ShoppingCart from "@/components/shopping-cart";
import { Link } from "wouter";

export default function DynamicPage() {
  const { slug } = useParams();
  const { data: page, isLoading, isError } = useQuery({
    queryKey: [`/api/pages/${slug}`],
    queryFn: async () => {
      const res = await fetch(`/api/pages/${slug}`);
      if (!res.ok) {
        throw new Error("Page not found");
      }
      return res.json();
    },
  });

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <Navigation />
        <ShoppingCart />
        <div className="pt-20 pb-16">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <Skeleton className="h-10 w-1/3 mb-8" />
            <Card>
              <CardContent className="p-8">
                <Skeleton className="h-6 w-full mb-4" />
                <Skeleton className="h-6 w-5/6 mb-4" />
                <Skeleton className="h-6 w-4/6 mb-6" />
                <Skeleton className="h-6 w-full mb-4" />
                <Skeleton className="h-6 w-5/6 mb-4" />
                <Skeleton className="h-6 w-4/6" />
              </CardContent>
            </Card>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  if (isError || !page) {
    return (
      <div className="min-h-screen bg-background">
        <Navigation />
        <ShoppingCart />
        <div className="pt-20 pb-16">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 className="text-3xl font-bold text-foreground mb-4">Page Not Found</h1>
            <p className="text-muted-foreground mb-8">The page you're looking for doesn't exist.</p>
            <Button asChild>
              <Link href="/">Go Home</Link>
            </Button>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  // Function to render content based on the ProseMirror-like structure
  const renderContent = (content: any) => {
    if (!content || !Array.isArray(content)) return null;

    return content.map((node: any, index: number) => {
      switch (node.type) {
        case 'heading':
          const level = node.attrs?.level || 1;
          const HeadingTag = `h${level}` as keyof JSX.IntrinsicElements;
          return (
            <HeadingTag key={index} className={`mb-4 ${level === 1 ? 'text-3xl font-bold' : level === 2 ? 'text-2xl font-semibold' : 'text-xl font-medium'}`}>
              {node.content?.map((textNode: any, textIndex: number) => (
                <span key={textIndex}>{textNode.text}</span>
              ))}
            </HeadingTag>
          );
        case 'paragraph':
          return (
            <p key={index} className="mb-4 text-muted-foreground leading-relaxed">
              {node.content?.map((textNode: any, textIndex: number) => (
                <span key={textIndex}>{textNode.text}</span>
              ))}
            </p>
          );
        default:
          return null;
      }
    });
  };

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      <ShoppingCart />
      <div className="pt-20 pb-16">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl md:text-4xl font-bold text-foreground mb-8">{page.title}</h1>
          <Card>
            <CardContent className="p-8">
              {renderContent(page.content?.content)}
            </CardContent>
          </Card>
        </div>
      </div>
      <Footer />
    </div>
  );
}