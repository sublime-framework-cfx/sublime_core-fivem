import moment from 'moment';

interface IDateProps {
  unixTime: number;
  formatDate?: string;
}

const ConvertUnixTimeToDate = ({ unixTime, formatDate = 'DD/MM/YYYY' }: IDateProps): string => {
  const unixTimeAsSec: number = moment.duration(unixTime, 'milliseconds').as('seconds');
  const date: string = moment.unix(unixTimeAsSec).format(formatDate);
  return date;
};

export default ConvertUnixTimeToDate;