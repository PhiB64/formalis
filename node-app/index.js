
import 'dotenv/config';
import express from 'express';


const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello');
});

app.listen(port, () => {
  console.log(`Express server running on port ${port}`);
});
