import {v4 as uuidv4} from 'uuid';

/**
 * Generate a random token for the server to use.
 * @returns {string} token
 */
export const Token: string = uuidv4();