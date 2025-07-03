import React, { useState } from 'react';
import {
    View,
    Text,
    TextInput,
    Pressable,
    ActivityIndicator,
    Alert,
} from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { router } from 'expo-router';
import { supabase } from '../lib/supabase';
import { FormInput, ScreenContainerForm} from '@/components';

const registerSchema = z
    .object({
        email: z.string().email('請輸入正確的 Email'),
        password: z.string().min(6, '密碼長度至少 6 位'),
        confirmPassword: z.string().min(6, '請再次輸入相同密碼'),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: '兩次輸入的密碼不一致',
        path: ['confirmPassword'],
    });

type RegisterForm = z.infer<typeof registerSchema>;

export default function SignupScreen() {
    const [showPwd, setShowPwd] = useState(false);

    const {
        control,
        handleSubmit,
        formState: { errors, isSubmitting },
    } = useForm<RegisterForm>({
        resolver: zodResolver(registerSchema),
        defaultValues: {
            email: '',
            password: '',
            confirmPassword: '',
        },
    });

    const onSubmit = async (data: RegisterForm) => {
        const { error } = await supabase.auth.signUp({
            email: data.email,
            password: data.password,
        });

        if (error) {
            Alert.alert('註冊失敗', error.message);
        } else {
            Alert.alert('註冊成功', '請至信箱收取驗證信並完成驗證');
            router.replace('/login');
        }
    };

    return (
        <ScreenContainerForm>
            <View className="flex-1 flex items-center justify-center px-10">
                {/* 電子信箱 */}
                <FormInput
                    control={control}
                    name="email"
                    label="電子信箱"
                    placeholder="輸入電子信箱"
                    keyboardType="email-address"
                    error={errors.email}
                />
                {/* 密碼 */}
                <FormInput
                    control={control}
                    name="password"
                    label="密碼"
                    placeholder="輸入密碼"
                    isPassword
                    error={errors.password}
                    className="mt-4"
                />
                {/* 密碼 */}
                <FormInput
                    control={control}
                    name="confirmPassword"
                    label="確認密碼"
                    placeholder="再次輸入密碼"
                    isPassword
                    error={errors.confirmPassword}
                    className="mt-4"
                />
                {/* 註冊按鈕 */}
                <Pressable
                    className={`w-44 h-12 rounded-full items-center justify-center mt-10 ${isSubmitting ? 'bg-gray-400' : 'bg-primary'
                        }`}
                    onPress={handleSubmit(onSubmit)}
                    disabled={isSubmitting}
                >
                    {isSubmitting ? (
                        <ActivityIndicator color="#fff" />
                    ) : (
                        <Text className="text-white text-lg font-semibold">註冊</Text>
                    )}
                </Pressable>

                {/* 返回登入 */}
                <Pressable
                    className="w-44 h-12 rounded-full bg-gray-500 items-center justify-center mt-5"
                    onPress={() => router.replace('/login')}
                >
                    <Text className="text-white text-lg font-semibold">
                        返回登入
                    </Text>
                </Pressable>
            </View>
        </ScreenContainerForm>
    );
}
