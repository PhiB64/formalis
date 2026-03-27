
import 'dotenv/config';
import express from 'express';


const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.sendStatus(200);
});

app.listen(port, () => {
  console.log(`Express server running on port ${port}`);
});
