import fetch from 'node-fetch';

async function runDemo() {
  try {
    const response = await fetch('https://tidecloak-api.com/endpoint', {
      method: 'GET',
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY',
        'Content-Type': 'application/json'
      }
    });

    const data = await response.json();
    console.log('🌐 External API Response:', data);
  } catch (error) {
    console.error('❌ API Call Failed:', error);
  }
}

runDemo();
