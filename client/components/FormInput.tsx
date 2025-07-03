// components/FormInput.tsx
import React, { useState } from 'react';
import { View, Text, TextInput, Pressable } from 'react-native';
import { Control, Controller, FieldError } from 'react-hook-form';
import { Feather } from '@expo/vector-icons';

interface FormInputProps {
    control: Control<any>;
    name: string;
    label: string;
    placeholder?: string;
    isPassword?: boolean;
    keyboardType?: 'default' | 'email-address' | 'numeric';
    autoCapitalize?: 'none' | 'sentences' | 'words' | 'characters';
    error?: FieldError;
    value?: string;
    className?: string;
    maxlength?: number;
}

export default function FormInput({
    control,
    name,
    label,
    placeholder,
    isPassword = false,
    error,
    maxlength,
    keyboardType = 'default',
    autoCapitalize = 'none',
    className = '',
}: FormInputProps) {
    const [showPwd, setShowPwd] = useState(false);

    return (
        <Controller
            control={control}
            name={name}
            render={({ field: { onChange, value } }) => (
                <View className={`w-full ${className}`}>
                    <Text className="text-xl font-semibold">{label}</Text>


                    <View className="flex-row items-center bg-gray-200 rounded mt-2 px-3">
                        <TextInput
                            className="flex-1 h-12"
                            placeholder={placeholder}
                            secureTextEntry={isPassword && !showPwd}
                            keyboardType={keyboardType}
                            autoCapitalize={autoCapitalize}
                            value={value}
                            onChangeText={onChange}
                            maxLength={maxlength}
                        />
                        {isPassword ? (
                            <Pressable onPress={() => setShowPwd((v) => !v)} className='p-2'>
                                <Feather
                                    name={showPwd ? 'eye' : 'eye-off'}
                                    size={24}
                                    color="gray"
                                />
                            </Pressable>
                        ) : null}

                    </View>
                    <View className="min-h-[20px] mt-1">
                        {error && (
                            <Text className="text-red-500">{error.message}</Text>
                        )}
                    </View>
                    {/* {error && <Text className="text-red-500 mt-1 z-1">{error.message}</Text>} */}
                </View>
            )}
        />
    );
}
