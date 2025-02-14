const app = require('./app');
require('dotenv').config();

const PORT = process.env.PORT;

app.listen(PORT || 3000, () => {
  console.log(`Server is running on https://localhost:${PORT}`);
});
