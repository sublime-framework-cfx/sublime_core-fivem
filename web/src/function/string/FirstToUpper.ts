export const firstToUpper = (str: string) => {
  str = str.toLowerCase();
  return str.replace(str[0], str[0].toUpperCase());
}