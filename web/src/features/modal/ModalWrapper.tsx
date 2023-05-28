import React, { useState, useEffect, Fragment } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { useDisclosure } from '@mantine/hooks';
import { useForm } from '@mantine/form';
import { useConfig } from '../../providers/ConfigProvider';
import { Stack, Group, Modal, Divider } from '@mantine/core';
import { InputField, SelectField, CheckboxField, DateInputField } from './components/custom';
import { fetchNui } from "../../utils/fetchNui";
import type { ModalPropsCustom, Option, SelectProps } from '../../typings';
import AnimatedButton from './components/buttons';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';

/*interface Option {
  type: string;
  label: string;
  description?: string;
  required?: boolean;
  default?: string | boolean | Date | number | Array<any>;
  format?: string;
  icon?: string | string[];
  placeholder?: string;
  max?: number;
  min?: number;
  step?: number;
  data?: Data;
  size?: string;
  callback?: boolean;
}

interface ModalPropsCustom {
  title: string;
  size?: string;
  options: Option[];
  useCallback?: boolean;
}*/

const ModalWrapper: React.FC = () => {
  const { config } = useConfig();
  //const useStyles = createStyles((theme) => ({...config.modalsStyles}));
  //const { classes } = useStyles();
  const [getData, setData] = useState<ModalPropsCustom>({title: '', options: []});
  const [opened, { close, open }] = useDisclosure(false);
  const form = useForm<{index: {value: any, required: boolean}[]}>({});

  useNuiEvent<ModalPropsCustom>('sl:modal:opened', async (data) => {
    const options = data.options;
    setData(data);
    console.log(options);
    options.forEach((field: Option, index: number) => {
      console.log(field, index);
      form.setFieldValue(`${index}`, 
        {
          value :
            field.type === 'input' ? field.default || '' 
            : field.type === 'checkbox' ? field.default || false
            : field.type === 'select' ? field.default || ''
            : field.type === 'date' ? field.default || ''
            : null,
          required: field.required || false,
          callback: field.callback || false
        });
    });
    await new Promise((resolve) => setTimeout(resolve, 200));
    open();
  });

  const handleSubmit = form.onSubmit(async (data) => {
    let missing = false;
    const setArray: any[] = [];
    Object.values(data).forEach((field: any, index: number) => {
      if (field.required) {
        const val = !field.value ? null : field.value;
        switch (val) {
          case null:
          case typeof val === 'boolean' && val !== true:
          case typeof val === 'string' && val.length <= 1:
            missing = true;
            const err = getData.options[index]?.error || null;
            form.setFieldError(index.toString(), err || 'Ce champ est requis');
            return;
          default: break;
        }
      }
      setArray.push(field.value);
    });
    if (missing) return;
    close();
    await new Promise((resolve) => setTimeout(resolve, 200));
    form.reset();
    fetchNui('sl:modal:submit', setArray, JSON.stringify(setArray));
  });

  const handleChange = (index: string, value: any, isRequired?: boolean, callback?: boolean) => {
    form.setFieldValue(`${index}`, { value , required: isRequired, callback: callback});
    if (callback && getData.useCallback) {
      fetchNui('sl:modal:callback', {index: parseInt(index) + 1, value: value})
    }
  };

  return (
    <>
      <Modal
        opened={opened}
        closeOnClickOutside={false}
        closeOnEscape={false}
        onClose={close}
        centered
        withCloseButton={false}
        styles={{ title: { textAlign: 'center', width: '100%', fontSize: 16 }}}
        transitionProps={{
          
        }}
        title={getData.title}
        size={getData.size || 'xs'}
      >
        <Divider variant='solid' />
        <Stack>
          <form onSubmit={handleSubmit}>
            {getData.options?.map((field: Option, index) => {
              return (
                <Fragment key={index}>
                  {
                    field.type === 'input' && (
                      <InputField
                        index={index.toString()}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'select' && (
                      <SelectField
                        index={index.toString()}
                        label={field.label}
                        options={field.options as SelectProps}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'checkbox' && (
                      <CheckboxField
                        index={index.toString()}
                        label={field.label}
                        data={field as any}
                        defaultValue={field.checked as boolean}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'date' && (
                      <DateInputField
                        index={index.toString()}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                </Fragment>
              );
            })}
            <Group position='center' pt={10}>
              <AnimatedButton
                iconAwesome={faXmark}
                text='Annuler'
                onClick={() => {close(); form.reset();}}
                color='red.6'
                args={false}
              />
              <AnimatedButton
                iconAwesome={faCheck}
                text='Valider'
                onClick={() => handleSubmit()}
                color='teal.6'
                args={true}
              />
            </Group>
          </form>
        </Stack>
      </Modal>
    </>
  );
};

export default ModalWrapper;
