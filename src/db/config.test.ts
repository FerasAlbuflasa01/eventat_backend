import pool from './config';

describe('Database Configuration', () => {
  it('should create a pool instance', () => {
    expect(pool).toBeDefined();
  });

  it('should have correct pool configuration', () => {
    expect(pool.options.max).toBe(20);
    expect(pool.options.idleTimeoutMillis).toBe(30000);
    expect(pool.options.connectionTimeoutMillis).toBe(2000);
  });
});
