import React, { useState, useEffect } from 'react';
import { Modal, TextInput, Select, Button, Stack, Group } from '@mantine/core';
import { CheckboxField, InputField, PasswordField } from '../components/custom';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import AnimatedButton from '../components/buttons';

interface Option {
  type: string;
  label: string;
  description?: string;
  required?: boolean;
  default?: string | boolean | Date;
  format?: string;
  icon?: string | string[];
  placeholder?: string;
  max?: number;
  min?: number;
}

interface ModalPropsCustom {
  title?: string;
  options: Option[];
  handleClose: () => void;
}

interface RenderedProps {
  index: number;
  field: Option;
}

export const OpenModalCustom: React.FC<ModalPropsCustom> = ({
  title,
  options,
  handleClose,
}) => {
  const [formData, setFormData] = useState<Record<string, string | boolean>>(
    {}
  );
  const [areRequiredFieldsCompleted, setRequiredFieldsCompleted] =
    useState(true);

  const handleInputChange = async (index: number, value: boolean | string) => {
    setFormData((prevData) => {
      const updatedData = { ...prevData };
      updatedData[index] = value;
      return updatedData;
    });
  };

  const handleSubmit = async () => {
    handleClose();
    console.log(formData);
  };

  const renderField = (field: Option, index: number) => {
    switch (field.type) {
      case 'input':
        return (
          <InputField
            key={index}
            index={index}
            label={field.label}
            data={field as Data}
            onChanged={handleInputChange}
          />
        );
      case 'checkbox':
        return (
          <CheckboxField
            key={index}
            index={index}
            label={field.label}
            defaultValue={
              (formData[index] as boolean) ||
              (field.default as boolean) ||
              false
            }
            onChanged={handleInputChange}
          />
        );
      case 'password':
        return (
          <PasswordField
            key={index}
            index={index}   
            label={field.label}
            data={field as Data}
            onChanged={handleInputChange}
          />
        );
      default:
        return null;
    }
  };

  const renderedFields: RenderedProps[] = options.map(
    (field: Option, index: number) => ({
      index,
      field,
    })
  );

  useEffect(() => {
    const requiredFields = renderedFields
      .filter(({ field }) => field.required)
      .map(({ index }) => index);
    const areAllRequiredFieldsCompleted = requiredFields.every((index) => {
      const fieldData = formData[index];
      return typeof fieldData !== 'undefined' && fieldData !== '';
    });
    setRequiredFieldsCompleted(areAllRequiredFieldsCompleted);
  }, [formData, renderedFields]);

  return (
    <>
      <Modal
        opened={true}
        size='xs'
        onClose={handleClose}
        title={title}
        withCloseButton={false}
        centered
        withOverlay={false}
        transitionProps={{
          transition: 'skew-up',
          duration: 300,
          keepMounted: true,
          timingFunction: 'ease-in-out',
        }}
      >
        <Stack style={{ padding: 10 }}>
          {renderedFields.map(({ field, index }) => renderField(field, index))}
        </Stack>
        <Group position='center'>
          <AnimatedButton
            iconAwesome={faXmark}
            text='Annuler'
            onClick={handleSubmit}
            color='red'
            args={false}
          />
          <AnimatedButton
            iconAwesome={faCheck}
            text='Valider'
            onClick={handleSubmit}
            color='green'
            args={true}
            isDisabled={!areRequiredFieldsCompleted}
          />
        </Group>
      </Modal>
    </>
  );
};

/*
local modals = supv.openModals({
    type = 'custom',
    title = 'Custom modal',
    options = {
        {type = 'input', label = 'Text input', description = 'Some input description', required = true, min = 4, max = 16},
        {type = 'number', label = 'Number input', description = 'Some number description', icon = 'hashtag'},
        {type = 'checkbox', label = 'Simple checkbox'},
        {type = 'color', label = 'Colour input', default = '#eb4034'},
        {type = 'date', label = 'Date input', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"}
    }
})

print(json.encode(modals))
*/
