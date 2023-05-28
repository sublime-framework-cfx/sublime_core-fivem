import React from 'react';
import { Checkbox } from '@mantine/core';

interface Props {
  index: string;
  label?: string;
  data?: any;
  defaultValue?: boolean;
  onChanged: (index: string, value: boolean, isRequired?: boolean, callback?: boolean) => void;
  props: any;
}

export const CheckboxField: React.FC<Props> = ({
  index,
  label,
  defaultValue,
  data,
  onChanged,
  props
}) => {
  return (
    <>
      <Checkbox
        sx={{ display: 'flex', paddingTop: '10px' }}
        label={label}
        defaultChecked={defaultValue || false}
        onChange={(event) => onChanged(index, event.target.checked, data?.required, data?.callback)}
        error={!defaultValue && props.error}
      />
    </>
  );
};
