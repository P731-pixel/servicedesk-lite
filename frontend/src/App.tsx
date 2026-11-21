import { Routes, Route, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import axios from 'axios';

function Home() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['ping'],
    queryFn: async () => {
      const response = await axios.get('http://localhost:5214/api/ping');
      return response.data;
    },
    retry: false,
  });

  return (
    <div style={{ padding: '2rem' }}>
      <h1>ServiceDesk Lite</h1>
      <p>Frontend is running successfully.</p>

      <div style={{ marginTop: '2rem', padding: '1rem', border: '1px solid #ccc' }}>
        <h3>Backend Health Check:</h3>
        {isLoading && <p>Checking connection to backend...</p>}
        {error && (
          <p style={{ color: 'red' }}>
            Backend is not reachable. Make sure it's running on port 5000.
          </p>
        )}
        {data && (
          <pre style={{ background: '#eee', padding: '1rem' }}>{JSON.stringify(data, null, 2)}</pre>
        )}
      </div>
    </div>
  );
}

function App() {
  return (
    <div>
      <nav style={{ padding: '1rem', background: '#333', color: 'white' }}>
        <Link to='/' style={{ color: 'white', textDecoration: 'none', marginRight: '1rem' }}>Home</Link>
      </nav>
      <Routes>
        <Route path='/' element={<Home />}/>
        <Route path='*' element={<div style={{ padding: '2rem' }}>404 Not Found</div>}/>
      </Routes>
    </div>
  )
}

export default App
