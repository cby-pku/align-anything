#!/usr/bin/env bash
#
# Copyright 2024 PKU-Alignment Team. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================


ACTOR_MODEL_NAME_OR_PATH="/aifs4su/yaodong/spring_r1/outputs/DeepSeek-R1-Distill-Llama-8B-Vision-Step2-0129-2/slice_5000" # model path
REWARD_MODEL_NAME_OR_PATH="/aifs4su/yaodong/spring_r1_model/OpenRLHF/Llama-3-8b-rm-mixture" # model path
CRITIC_MODEL_NAME_OR_PATH="/aifs4su/yaodong/spring_r1_model/OpenRLHF/Llama-3-8b-rm-mixture" # model path

TRAIN_DATASETS="/aifs4su/yaodong/spring_r1/mm_zero_rl_boyuan/lmm-r1/examples/data/math_data" # dataset path
TRAIN_TEMPLATE='MM-Zero-RL-Boyuan'
# TRAIN_NAME="text-to-text" # dataset name
TRAIN_SPLIT="train" # split the dataset




OUTPUT_DIR="../test_outputs/align_ds_v_local_rm_grpo" # output dir
# For wandb online logging
export WANDB_API_KEY='beaf8a16340b17e63719218d56b1faf6b6cbbf40'

# Source the setup script
source ./setup.sh

# Execute deepspeed command
deepspeed \
    --master_port ${MASTER_PORT} \
    --module align_anything.trainers.text_to_text.grpo \
    --actor_model_name_or_path ${ACTOR_MODEL_NAME_OR_PATH} \
    --reward_model_name_or_path ${REWARD_MODEL_NAME_OR_PATH} \
    --reward_critic_model_name_or_path ${CRITIC_MODEL_NAME_OR_PATH} \
    --train_datasets ${TRAIN_DATASETS} \
    --train_template ${TRAIN_TEMPLATE} \
    --train_split ${TRAIN_SPLIT} \
    --output_dir ${OUTPUT_DIR} \
    --save_interval 10 \
    --epochs 10
