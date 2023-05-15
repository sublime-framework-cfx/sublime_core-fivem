import React, { useState } from 'react';
import { Modal, TextInput, Button, Stack, Group } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
import { fetchNui } from '../../../utils/fetchNui';
import AnimatedButton from '../../modal/components/buttons';
import { DateInput } from '@mantine/dates';

interface DataPropsIdentity {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
}

interface NewCharModalProps {
    title: string;
}

export const NewCharModal: React.FC = () => {
  const [formData, setFormData] = useState<DataPropsIdentity>({
    firstName: '',
    lastName: '',
    dateOfBirth: '',
  });
  const [opened, setOpened] = useState(true);

  const handleSubmit = async (type: any) => {
    if (!type) return;
    await new Promise((resolve) => setTimeout(resolve, 200));
    //fetchNui('sl:modal:closedCustom');
    setOpened(false);
  };

  
  const handleInputChange = (name: 'firstName' | 'lastName' | 'dateOfBirth', value: string) => {
    setFormData((prevData) => {
      const updatedData = { ...prevData };
      updatedData[name] = value;
      return updatedData;
    });
  };

  const formatDate = (date: Date | null): string => {
    return date
      ? date.toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        })
      : '';
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

  setFormData({ ...formData, dateOfBirth: onPlaceHolder(new Date())})
  return (
    <>
        { console.log('formData')}
      <Modal
        opened={true}
        onClose={() => handleSubmit(false)}
        title='Nouveau personnage'
        size='xs'
        centered
        withCloseButton={false}
      >
        <Stack spacing='md'>
          <TextInput
            label='First Name'
            placeholder='John'
            required
            onChange={(event) =>
              handleInputChange('firstName', event.currentTarget.value)
            }
          />
          <TextInput
            label='Last Name'
            placeholder='Doe'
            required
            onChange={(event) =>
              handleInputChange('lastName', event.currentTarget.value)
            }
          />
          <DateInput
            value={new Date()}
            onChange={(event) =>
              console.log(event)
            }
            label='Date input'
            placeholder={formData.dateOfBirth}
            valueFormat='DD/MM/YYYY'
            maw={400}
            mx='auto'
          />
        </Stack>
        <Group position='right'></Group>
      </Modal>
    </>
  );
};