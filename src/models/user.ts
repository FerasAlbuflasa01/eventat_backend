import pool from '../db/config';
import bcrypt from 'bcrypt';
import { User } from '../types';

const SALT_ROUNDS = 10;

export async function createUser(email: string, password: string): Promise<User> {
  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);
  
  const result = await pool.query(
    `INSERT INTO users (email, password_hash)
     VALUES ($1, $2)
     RETURNING id, email, password_hash as "passwordHash", created_at as "createdAt", updated_at as "updatedAt"`,
    [email, passwordHash]
  );
  
  return result.rows[0];
}

export async function findByEmail(email: string): Promise<User | null> {
  const result = await pool.query(
    `SELECT id, email, password_hash as "passwordHash", created_at as "createdAt", updated_at as "updatedAt"
     FROM users
     WHERE email = $1`,
    [email]
  );
  
  return result.rows[0] || null;
}

export async function findById(id: string): Promise<User | null> {
  const result = await pool.query(
    `SELECT id, email, password_hash as "passwordHash", created_at as "createdAt", updated_at as "updatedAt"
     FROM users
     WHERE id = $1`,
    [id]
  );
  
  return result.rows[0] || null;
}

export async function verifyPassword(password: string, passwordHash: string): Promise<boolean> {
  return bcrypt.compare(password, passwordHash);
}
