FROM node:22-bookworm-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY src ./src

ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

CMD ["npm", "start"]

