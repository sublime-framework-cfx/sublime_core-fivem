const exp: any = (global as any).exports;

import token from "./token";
import ConvertUnixTimeToDate from "unixtime";

/**
 * Generate a random token for the server to use.
 * @returns {string} token 
*/
exp('token', () => {
    return token;
});


/**
 * Convert a unix time to a date.
 * @param {number} unixTime - The unix time to convert.
 * @param {string} formatDate - The format to convert the date to.
 * @returns {string} date
*/
exp('convertUnixTimeToDate', (unixTime: number, formatDate: string = 'DD/MM/YYYY') => {
    return ConvertUnixTimeToDate({ unixTime, formatDate });
});