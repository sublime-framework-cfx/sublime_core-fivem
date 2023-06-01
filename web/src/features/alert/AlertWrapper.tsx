import React, { useState } from 'react';
import { useDisclosure } from '@mantine/hooks';
import { Dialog, Stack, Text, Group, Title } from '@mantine/core';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import AnimatedButton from '../modal/components/buttons';

interface Props {
	title?: string;
	description?: string;
}

const AlertWrapper: React.FC = () => {
	const [values, setValues] = useState<Props>({});
  const [opened, { close, open }] = useDisclosure(false);

	useNuiEvent('sl:alert:opened', async (data) => {
		setValues(data);
		await new Promise((resolve) => setTimeout(resolve, 200));
		open();
	});

	const handleConfirm = async (value: boolean) => {
		close();
		await new Promise((resolve) => setTimeout(resolve, 200));
		fetchNui('sl:alert:confirm', value);
	};

  return (
		<>
			<Dialog
				//title="Alert title"
				opened={opened}
				onClose={close}
				position={{top: '50%', right: 0}}
				//hideCloseButton
			>
				<Stack spacing="xs">
					<Title align='center' order={4}>{values.title}</Title>
					<Text size="sm" weight={500} italic={true}>
						{values.description}
					</Text>
				</Stack>
				<Group align='center' position='center' pt={10}>
            <AnimatedButton
              iconAwesome={faXmark}
              text='Annuler'
              onClick={() => handleConfirm(false)}
              color='red.6'
              args={false}
            />
            <AnimatedButton
              iconAwesome={faCheck}
              text='Valider'
              onClick={() => handleConfirm(true)}
              color='teal.6'
              args={true}
            />
          </Group>
			</Dialog>
		</>
	);
};

export default AlertWrapper;