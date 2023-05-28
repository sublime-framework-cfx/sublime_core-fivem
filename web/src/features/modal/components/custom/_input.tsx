import React from 'react';
import { TextInput } from '@mantine/core';

interface Props {
  index: string;
  label?: string;
  data?: any;
  onChanged: (index: string, value: string, isRequired?: boolean, callback?: boolean) => void;
  props: any;
}

export const InputField: React.FC<Props> = ({
  index,
  label,
  data,
  onChanged,
  props
}) => {
  return (
    <>
      <TextInput
        label={label}
        sx={{ paddingTop: '10px' }}
        placeholder={data?.placeholder || ''}
        description={data?.description || ''}
        required={data?.required || false}
        minLength={data?.min || 0}
        maxLength={data?.max || 255}
        onChange={(event) => onChanged(index, event.target.value, data?.required || false, data?.callback || false)}
        error={props.error || false}
      />
    </>
  );
};
