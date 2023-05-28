import { useState } from 'react';
import { DateInput } from '@mantine/dates';

interface Props {
    index: string;
    label?: string;
    data?: any;
    onChanged: (index: string, value: string, isRequired?: boolean, callback?: boolean) => void;
    props: any;
}

export const DateInputField: React.FC<Props> = ({index, label, data, onChanged, props}) => {
  const [value, setValue] = useState<Date | null>(null);

  const formatDate = (date: Date | null): string => {
    return date
      ? date.toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        })
      : '';
  };

  const handlerChange = (date: Date | null) => {
    setValue(date);
    onChanged(index, formatDate(date), data?.required, data?.callback);
  };

  const onPlaceHolder = (date: Date | null): string => {
    return date
      ? formatDate(date)
      : new Date().toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        });
  };

  return (
      <DateInput
        value={value}
        sx={{ paddingTop: '10px' }}
        popoverProps={{ withinPortal: true, position: 'top' }}
        onChange={handlerChange}
        label={label}
        placeholder={onPlaceHolder(value)}
        valueFormat='DD/MM/YYYY'
        mx='xs'
        required={data?.required || false}
        error={props.error || false}
        withAsterisk={data?.required || false}
      />
  );
};