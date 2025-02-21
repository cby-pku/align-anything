export DATASET="/aifs4su/yaodong/spring_r1/mm_zero_rl_boyuan/lmm-r1/examples/data/mathlv345_8k_chatml.json"


MODEL_CPK_NAME="qwenvl2_2B_ins_rloo_math_test_remote_rm"
PRETRAIN_MODEL="Qwen/Qwen2-VL-2B-Instruct"
SAVE_PATH="/aifs4su/yaodong/spring_r1/mm_zero_rl_boyuan/outputs/test_output"
mkdir -p "${SAVE_PATH}/${MODEL_CPK_NAME}"

export WANDB_API_KEY='beaf8a16340b17e63719218d56b1faf6b6cbbf40'
python math_verifier.py --dataset $DATASET --input_key prompt --prompt-template chatml > "${SAVE_PATH}/${MODEL_CPK_NAME}/remote_rm.log" 2>&1 &
childpid=$!



# 等待Flask服务器启动，最多尝试6次
max_attempts=6
attempt=1
while [ $attempt -le $max_attempts ]
do
    sleep 5
    if curl -s -X GET http://localhost:7000 > /dev/null 2>&1; then
        break
    fi
    echo "Waiting for server to start... Attempt $attempt of $max_attempts"
    attempt=$((attempt + 1))
done

echo "remote rm done"

curl -X POST http://localhost:7000/get_reward \
-H "Content-Type: application/json" \
-d '{
  "query": ["<|im_start|>user\n求解方程 x + 1 = 2<|im_end|><|im_start|>assistant\n<think>让我来解这个简单的方程。\nx + 1 = 2\n将1移到等号右边\nx = 2 - 1\nx = 1</think><answer>$x=1$</answer>"],
  "prompts": ["求解方程 x + 1 = 2"]
}'

kill $childpid
echo "childpid killed"