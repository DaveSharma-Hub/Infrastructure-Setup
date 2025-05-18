import express from 'express';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

const portArg = process.argv[2] || '3000';
const PORT = Number.parseInt(portArg);

app.get('/test', (_, res)=>{
    res.send({
        data:"Hello World"
    });
});

app.listen(PORT, () => {
    console.log(`Listening on ${PORT}`)
});