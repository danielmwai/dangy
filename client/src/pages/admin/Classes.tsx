import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { 
  Table, 
  TableBody, 
  TableCell, 
  TableHead, 
  TableHeader, 
  TableRow 
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import adminApi from '@/lib/adminApi';

export default function ClassesPage() {
  const queryClient = useQueryClient();
  const { data: classes, isLoading, refetch } = useQuery({
    queryKey: ['admin', 'classes'],
    queryFn: () => adminApi.get('/classes'),
  });

  const [newClass, setNewClass] = useState({
    name: '',
    description: '',
    duration: 60,
    level: 'beginner',
    instructor: '',
    maxCapacity: 20,
    active: true
  });

  const createClassMutation = useMutation({
    mutationFn: (classData: any) => adminApi.post('/classes', classData),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'classes'] });
      setNewClass({
        name: '',
        description: '',
        duration: 60,
        level: 'beginner',
        instructor: '',
        maxCapacity: 20,
        active: true
      });
    },
  });

  const updateClassMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) => adminApi.patch(`/classes/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'classes'] });
    },
  });

  const deleteClassMutation = useMutation({
    mutationFn: (id: string) => adminApi.delete(`/classes/${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['admin', 'classes'] });
    },
  });

  const handleCreateClass = (e: React.FormEvent) => {
    e.preventDefault();
    createClassMutation.mutate(newClass);
  };

  const toggleClassStatus = (classId: string, currentStatus: boolean) => {
    updateClassMutation.mutate({ 
      id: classId, 
      data: { active: !currentStatus } 
    });
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Manage Classes</h1>
          <p className="text-muted-foreground">Add, edit, and manage fitness classes</p>
        </div>
        <Dialog>
          <DialogTrigger asChild>
            <Button>Add New Class</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Add New Class</DialogTitle>
              <DialogDescription>
                Create a new fitness class for your members
              </DialogDescription>
            </DialogHeader>
            <form onSubmit={handleCreateClass} className="space-y-4">
              <div>
                <Label htmlFor="name">Class Name</Label>
                <Input
                  id="name"
                  value={newClass.name}
                  onChange={(e) => setNewClass({ ...newClass, name: e.target.value })}
                  required
                />
              </div>
              <div>
                <Label htmlFor="description">Description</Label>
                <Input
                  id="description"
                  value={newClass.description}
                  onChange={(e) => setNewClass({ ...newClass, description: e.target.value })}
                  required
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="duration">Duration (minutes)</Label>
                  <Input
                    id="duration"
                    type="number"
                    value={newClass.duration}
                    onChange={(e) => setNewClass({ ...newClass, duration: parseInt(e.target.value) })}
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="level">Level</Label>
                  <select
                    id="level"
                    value={newClass.level}
                    onChange={(e) => setNewClass({ ...newClass, level: e.target.value })}
                    className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                  >
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                  </select>
                </div>
              </div>
              <div>
                <Label htmlFor="instructor">Instructor</Label>
                <Input
                  id="instructor"
                  value={newClass.instructor}
                  onChange={(e) => setNewClass({ ...newClass, instructor: e.target.value })}
                />
              </div>
              <div>
                <Label htmlFor="maxCapacity">Max Capacity</Label>
                <Input
                  id="maxCapacity"
                  type="number"
                  value={newClass.maxCapacity}
                  onChange={(e) => setNewClass({ ...newClass, maxCapacity: parseInt(e.target.value) })}
                />
              </div>
              <Button type="submit" className="w-full">
                Create Class
              </Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="border rounded-lg">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Description</TableHead>
              <TableHead>Duration</TableHead>
              <TableHead>Level</TableHead>
              <TableHead>Instructor</TableHead>
              <TableHead>Capacity</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {classes?.map((fitnessClass: any) => (
              <TableRow key={fitnessClass.id}>
                <TableCell className="font-medium">{fitnessClass.name}</TableCell>
                <TableCell>{fitnessClass.description}</TableCell>
                <TableCell>{fitnessClass.duration} min</TableCell>
                <TableCell>{fitnessClass.level}</TableCell>
                <TableCell>{fitnessClass.instructor}</TableCell>
                <TableCell>{fitnessClass.maxCapacity}</TableCell>
                <TableCell>
                  <span className={`px-2 py-1 rounded-full text-xs ${
                    fitnessClass.active 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-red-100 text-red-800'
                  }`}>
                    {fitnessClass.active ? 'Active' : 'Inactive'}
                  </span>
                </TableCell>
                <TableCell>
                  <div className="flex space-x-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => toggleClassStatus(fitnessClass.id, fitnessClass.active)}
                    >
                      {fitnessClass.active ? 'Deactivate' : 'Activate'}
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        if (confirm(`Are you sure you want to delete class ${fitnessClass.name}?`)) {
                          deleteClassMutation.mutate(fitnessClass.id);
                        }
                      }}
                    >
                      Delete
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}