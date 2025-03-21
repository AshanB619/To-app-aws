import React, { useEffect, useState } from 'react';
import '../src/App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [form, setForm] = useState({ name: '', price: '' });

  const API_URL = 'http://localhost:3000'; // Your backend running locally

  const fetchProducts = async () => {
    try {
      const res = await fetch(`${API_URL}/products`);
      const data = await res.json();
      setProducts(data);
    } catch (error) {
      console.error('Failed to fetch products', error);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await fetch(`${API_URL}/products`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      });
      setForm({ name: '', price: '' });
      fetchProducts(); // Refresh
    } catch (error) {
      console.error('Failed to add product', error);
    }
  };

  return (
    <div className="App">
      <h1>Product Catalog</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Product Name"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          required
        />
        <input
          type="number"
          placeholder="Price"
          value={form.price}
          onChange={(e) => setForm({ ...form, price: e.target.value })}
          required
        />
        <button type="submit">Add Product</button>
      </form>
      <ul>
        {products.length === 0 ? (
          <li>No products yet.</li>
        ) : (
          products.map((p, i) => (
            <li key={i}>
              {p.name} - ${p.price}
            </li>
          ))
        )}
      </ul>
    </div>
  );
}

export default App;
