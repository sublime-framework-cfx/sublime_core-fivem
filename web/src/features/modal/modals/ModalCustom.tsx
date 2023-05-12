import React, { useState } from 'react';
import { Modal, TextInput, Select, Button, Stack } from '@mantine/core';
import { CheckboxField, InputField, Data } from '../components/custom';


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
    options: Option;
    handleClose: () => void;
}

export const OpenModalCustom: React.FC<ModalPropsCustom> = ({ title, options, handleClose }) => {
    const [formData, setFormData] = useState<Record<string, string | boolean>>({});

    const handleInputChange = (index: number, value: boolean | string) => {
        setFormData((prevData) => {
            const updatedData = { ...prevData };
            updatedData[index] = value;
            return updatedData;
        });

    };

    const handleSubmit = () => {
        handleClose();
        console.log(formData);
    };

    const renderField = (field: Option, index: number) => {
        switch (field.type) {
            case 'input':
                return <InputField key={index} index={index} label={field.label} data={field as Data} onChanged={handleInputChange} />
            case 'checkbox':
                return <CheckboxField key={index} index={index} label={field.label} defaultValue={formData[index] as boolean || (field.default as boolean) || false} onChanged={handleInputChange} />
            default: return null;
        }
    };

    return (
        <>
            <Modal
                opened={true}
                size='xs'
                onClose={handleClose}
                title={title}
            >

                <Stack style={{ padding: 10 }}>
                    {Array.isArray(options) && options.map((field: Option, index: number) => renderField(field, index))}
                </Stack>
                <Button style={{ padding: 10 }} onClick={handleSubmit}>Soumettre</Button>
            </Modal>
        </>
    );
}

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